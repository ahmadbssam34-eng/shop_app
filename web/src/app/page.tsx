'use client';

import { useProducts } from '@/lib/rtdb';
import { ProductCard } from '@/components/product-card';

export default function HomePage() {
  const { products, loading } = useProducts();

  return (
    <div className="space-y-4">
      <div>
        <h1 className="text-2xl font-bold text-gray-900">Products</h1>
        <p className="text-sm text-gray-600">Live data from Firebase Realtime Database.</p>
      </div>
      {loading ? (
        <p>Loading...</p>
      ) : products.length === 0 ? (
        <p>No products yet.</p>
      ) : (
        <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
          {products.map((p) => (
            <ProductCard key={p.id} product={p} />
          ))}
        </div>
      )}
    </div>
  );
}
