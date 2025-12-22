'use client';

import { useEffect, useState } from 'react';
import { notFound, useParams } from 'next/navigation';
import Image from 'next/image';
import { getProductOnce, type Product } from '@/lib/rtdb';
import { useCart } from '@/lib/cart';

export default function ProductDetailsPage() {
  const params = useParams<{ id: string }>();
  const [product, setProduct] = useState<Product | null>(null);
  const [loading, setLoading] = useState(true);
  const { add } = useCart();

  useEffect(() => {
    (async () => {
      if (!params?.id) return;
      const res = await getProductOnce(params.id);
      setProduct(res);
      setLoading(false);
    })();
  }, [params?.id]);

  if (loading) return <p>Loading...</p>;
  if (!product) return notFound();

  const canBuy = product.stock === null || product.stock === undefined || product.stock > 0;

  return (
    <div className="grid gap-6 md:grid-cols-2">
      <div className="rounded-lg border bg-white p-4 shadow-sm">
        {product.imageUrl ? (
          <div className="relative h-80 w-full overflow-hidden rounded-lg bg-gray-100">
            <Image src={product.imageUrl} alt={product.name} fill sizes="480px" className="object-cover" />
          </div>
        ) : (
          <div className="flex h-80 items-center justify-center rounded-lg bg-gray-100 text-gray-500">No image</div>
        )}
      </div>
      <div className="space-y-3">
        <h1 className="text-3xl font-bold text-gray-900">{product.name}</h1>
        <p className="text-gray-700">{product.desc ?? product.desc_en ?? '—'}</p>
        <p className="text-lg font-semibold text-indigo-700">{product.price.toFixed(2)} QAR</p>
        <p className="text-sm text-gray-600">
          Stock:{' '}
          {product.stock === null || product.stock === undefined ? 'N/A' : product.stock <= 0 ? 'Out of stock' : product.stock}
        </p>
        <button
          onClick={() => add(product, 1)}
          disabled={!canBuy}
          className="rounded-md bg-indigo-600 px-4 py-2 text-white hover:bg-indigo-700 disabled:cursor-not-allowed disabled:bg-gray-300"
        >
          {canBuy ? 'Add to cart' : 'Out of stock'}
        </button>
      </div>
    </div>
  );
}
