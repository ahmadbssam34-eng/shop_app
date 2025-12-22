'use client';

import Link from 'next/link';
import { useCart } from '@/lib/cart';

export default function CartPage() {
  const { items, remove, updateQty, total } = useCart();
  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Cart</h1>
      {items.length === 0 ? (
        <p>
          Cart is empty. <Link href="/">Continue shopping</Link>
        </p>
      ) : (
        <div className="space-y-3">
          {items.map((item) => (
            <div key={item.productId} className="flex items-center justify-between rounded-lg border bg-white p-3">
              <div>
                <div className="font-semibold text-gray-900">{item.name}</div>
                <div className="text-sm text-gray-600">{item.price.toFixed(2)} QAR</div>
                <div className="text-xs text-gray-500">
                  Stock: {item.stock === undefined || item.stock === null ? 'N/A' : item.stock}
                </div>
              </div>
              <div className="flex items-center gap-2">
                <input
                  type="number"
                  min={1}
                  value={item.qty}
                  onChange={(e) => updateQty(item.productId, Number(e.target.value))}
                  className="w-16 rounded border px-2 py-1 text-sm"
                />
                <button onClick={() => remove(item.productId)} className="text-sm text-red-600 hover:text-red-700">
                  Remove
                </button>
              </div>
            </div>
          ))}
          <div className="flex items-center justify-between rounded-lg border bg-white p-4">
            <div className="text-lg font-semibold">Total: {total.toFixed(2)} QAR</div>
            <Link href="/checkout" className="rounded-md bg-indigo-600 px-4 py-2 text-white hover:bg-indigo-700">
              Checkout
            </Link>
          </div>
        </div>
      )}
    </div>
  );
}
