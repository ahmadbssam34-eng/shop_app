'use client';

import Image from 'next/image';
import Link from 'next/link';
import { Product } from '@/lib/rtdb';
import { useCart } from '@/lib/cart';

type Props = {
  product: Product;
};

export function ProductCard({ product }: Props) {
  const { add } = useCart();
  const canBuy = product.stock === null || product.stock === undefined || product.stock > 0;
  return (
    <div className="flex flex-col rounded-lg border bg-white shadow-sm">
      {product.imageUrl ? (
        // Use next/image with fill? Keep simple fixed height.
        <div className="relative h-48 w-full overflow-hidden rounded-t-lg bg-gray-100">
          <Image src={product.imageUrl} alt={product.name} fill sizes="320px" className="object-cover" />
        </div>
      ) : (
        <div className="flex h-48 items-center justify-center rounded-t-lg bg-gray-100 text-gray-500">No image</div>
      )}
      <div className="flex flex-1 flex-col gap-2 p-4">
        <Link href={`/products/${product.id}`} className="text-lg font-semibold text-gray-900 hover:text-indigo-700">
          {product.name}
        </Link>
        <p className="text-sm text-gray-600 line-clamp-2">{product.desc ?? product.desc_en ?? '—'}</p>
        <div className="mt-auto flex items-center justify-between">
          <span className="text-lg font-bold text-indigo-700">{product.price.toFixed(2)} QAR</span>
          <button
            onClick={() => add(product, 1)}
            disabled={!canBuy}
            className="rounded-md bg-indigo-600 px-3 py-1 text-sm font-medium text-white hover:bg-indigo-700 disabled:cursor-not-allowed disabled:bg-gray-300"
          >
            {canBuy ? 'Add to cart' : 'Out of stock'}
          </button>
        </div>
      </div>
    </div>
  );
}
