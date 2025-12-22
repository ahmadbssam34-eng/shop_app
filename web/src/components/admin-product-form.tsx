'use client';

import { FormEvent, useEffect, useState, type ChangeEvent } from 'react';
import { useRouter } from 'next/navigation';
import { getFirebase } from '@/lib/firebase';
import { ref, push, set, get } from 'firebase/database';
import { useAuth } from '@/lib/auth-context';

type AdminProductFormProps = {
  productId?: string;
};

type ProductFormState = {
  name: string;
  name_en: string;
  desc: string;
  desc_en: string;
  descExtra: string;
  descExtra_en: string;
  price: string;
  stock: string;
  imageUrl: string;
  beforeUrl: string;
  afterUrl: string;
  galleryRaw: string;
  createdAt?: number | null;
};

const emptyState: ProductFormState = {
  name: '',
  name_en: '',
  desc: '',
  desc_en: '',
  descExtra: '',
  descExtra_en: '',
  price: '0',
  stock: '0',
  imageUrl: '',
  beforeUrl: '',
  afterUrl: '',
  galleryRaw: '',
  createdAt: null,
};

export function AdminProductForm({ productId }: AdminProductFormProps) {
  const { user, isAdmin } = useAuth();
  const router = useRouter();
  const [state, setState] = useState<ProductFormState>(emptyState);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const { db } = getFirebase();

  useEffect(() => {
    if (!productId) return;
    (async () => {
      setLoading(true);
      try {
        const snap = await get(ref(db, `products/${productId}`));
        const v = snap.val();
        if (v) {
          setState({
            name: v.name ?? '',
            name_en: v.name_en ?? '',
            desc: v.desc ?? '',
            desc_en: v.desc_en ?? '',
            descExtra: v.descExtra ?? '',
            descExtra_en: v.descExtra_en ?? '',
            price: v.price?.toString() ?? '0',
            stock: v.stock?.toString() ?? '0',
            imageUrl: v.imageUrl ?? '',
            beforeUrl: v.beforeAfter?.beforeUrl ?? '',
            afterUrl: v.beforeAfter?.afterUrl ?? '',
            galleryRaw: Array.isArray(v.gallery) ? v.gallery.join('\n') : '',
            createdAt: typeof v.createdAt === 'number' ? v.createdAt : null,
          });
        }
      } finally {
        setLoading(false);
      }
    })();
  }, [db, productId]);

  const onChange = (key: keyof ProductFormState) => (e: ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) =>
    setState((s) => ({ ...s, [key]: e.target.value }));

  const handleSubmit = async (e: FormEvent) => {
    e.preventDefault();
    if (!user || !isAdmin) {
      setError('Not authorized');
      return;
    }
    setLoading(true);
    setError(null);
    try {
      const payload = {
        name: state.name,
        name_en: state.name_en,
        desc: state.desc,
        desc_en: state.desc_en,
        descExtra: state.descExtra,
        descExtra_en: state.descExtra_en,
        price: Number(state.price),
        stock: Number(state.stock),
        imageUrl: state.imageUrl,
        gallery: state.galleryRaw
          .split('\n')
          .map((l) => l.trim())
          .filter(Boolean),
        beforeAfter: {
          beforeUrl: state.beforeUrl,
          afterUrl: state.afterUrl,
        },
        updatedAt: Date.now(),
      };

      if (productId) {
        await set(ref(db, `products/${productId}`), {
          ...payload,
          createdAt: state.createdAt ?? Date.now(),
        });
      } else {
        await set(push(ref(db, 'products')), {
          ...payload,
          createdAt: Date.now(),
        });
      }
      router.push('/admin');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Save failed');
    } finally {
      setLoading(false);
    }
  };

  const handleDelete = async () => {
    if (!productId) return;
    if (!confirm('Delete this product?')) return;
    await set(ref(db, `products/${productId}`), null);
    router.push('/admin');
  };

  return (
    <form onSubmit={handleSubmit} className="space-y-3">
      <div className="grid gap-3 md:grid-cols-2">
        <div>
          <label className="block text-sm font-medium text-gray-700">Name (AR)</label>
          <input value={state.name} onChange={onChange('name')} required className="mt-1 w-full rounded-md border px-3 py-2" />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">Name (EN)</label>
          <input value={state.name_en} onChange={onChange('name_en')} className="mt-1 w-full rounded-md border px-3 py-2" />
        </div>
      </div>
      <div className="grid gap-3 md:grid-cols-2">
        <div>
          <label className="block text-sm font-medium text-gray-700">Price</label>
          <input
            type="number"
            min={0}
            step="0.01"
            value={state.price}
            onChange={onChange('price')}
            required
            className="mt-1 w-full rounded-md border px-3 py-2"
          />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">Stock</label>
          <input
            type="number"
            min={0}
            value={state.stock}
            onChange={onChange('stock')}
            required
            className="mt-1 w-full rounded-md border px-3 py-2"
          />
        </div>
      </div>
      <div className="grid gap-3 md:grid-cols-2">
        <div>
          <label className="block text-sm font-medium text-gray-700">Desc (AR)</label>
          <textarea value={state.desc} onChange={onChange('desc')} className="mt-1 w-full rounded-md border px-3 py-2" />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">Desc (EN)</label>
          <textarea value={state.desc_en} onChange={onChange('desc_en')} className="mt-1 w-full rounded-md border px-3 py-2" />
        </div>
      </div>
      <div className="grid gap-3 md:grid-cols-2">
        <div>
          <label className="block text-sm font-medium text-gray-700">Extra Desc (AR)</label>
          <textarea value={state.descExtra} onChange={onChange('descExtra')} className="mt-1 w-full rounded-md border px-3 py-2" />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">Extra Desc (EN)</label>
          <textarea value={state.descExtra_en} onChange={onChange('descExtra_en')} className="mt-1 w-full rounded-md border px-3 py-2" />
        </div>
      </div>
      <div className="grid gap-3 md:grid-cols-2">
        <div>
          <label className="block text-sm font-medium text-gray-700">Main Image URL</label>
          <input value={state.imageUrl} onChange={onChange('imageUrl')} className="mt-1 w-full rounded-md border px-3 py-2" />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">Gallery URLs (one per line)</label>
          <textarea
            value={state.galleryRaw}
            onChange={onChange('galleryRaw')}
            className="mt-1 w-full rounded-md border px-3 py-2"
            rows={3}
          />
        </div>
      </div>
      <div className="grid gap-3 md:grid-cols-2">
        <div>
          <label className="block text-sm font-medium text-gray-700">Before URL</label>
          <input value={state.beforeUrl} onChange={onChange('beforeUrl')} className="mt-1 w-full rounded-md border px-3 py-2" />
        </div>
        <div>
          <label className="block text-sm font-medium text-gray-700">After URL</label>
          <input value={state.afterUrl} onChange={onChange('afterUrl')} className="mt-1 w-full rounded-md border px-3 py-2" />
        </div>
      </div>
      {error && <p className="text-sm text-red-600">{error}</p>}
      <div className="flex items-center gap-3">
        <button
          type="submit"
          disabled={loading}
          className="rounded-md bg-indigo-600 px-4 py-2 text-white hover:bg-indigo-700 disabled:opacity-70"
        >
          {loading ? 'Saving...' : 'Save'}
        </button>
        {productId && (
          <button type="button" onClick={handleDelete} className="text-sm text-red-600 hover:text-red-700">
            Delete
          </button>
        )}
      </div>
    </form>
  );
}
