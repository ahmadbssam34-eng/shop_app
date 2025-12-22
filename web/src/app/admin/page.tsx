'use client';

import Link from 'next/link';
import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth-context';
import { useProducts } from '@/lib/rtdb';

export default function AdminHome() {
  const { user, isAdmin, loading } = useAuth();
  const router = useRouter();
  const { products } = useProducts();

  useEffect(() => {
    if (!loading && (!user || !isAdmin)) router.replace('/login?next=/admin');
  }, [loading, user, isAdmin, router]);

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h1 className="text-2xl font-bold">Admin Products</h1>
        <Link href="/admin/products/new" className="rounded-md bg-indigo-600 px-4 py-2 text-white hover:bg-indigo-700">
          Add Product
        </Link>
      </div>
      <div className="space-y-2">
        {products.map((p) => (
          <div key={p.id} className="flex items-center justify-between rounded-lg border bg-white p-3 shadow-sm">
            <div>
              <div className="font-semibold text-gray-900">{p.name}</div>
              <div className="text-sm text-gray-600">
                {p.price.toFixed(2)} QAR • Stock: {p.stock ?? 'N/A'}
              </div>
            </div>
            <Link href={`/admin/products/${p.id}`} className="text-sm text-indigo-600 hover:text-indigo-700">
              Edit
            </Link>
          </div>
        ))}
        {products.length === 0 && <p>No products yet.</p>}
      </div>
    </div>
  );
}
