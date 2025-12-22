'use client';

import { useEffect, useState } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth-context';
import { useCart } from '@/lib/cart';
import { decrementStock, createOrder } from '@/lib/rtdb';
import { getFirebase } from '@/lib/firebase';
import { ref, child } from 'firebase/database';

export default function CheckoutPage() {
  const router = useRouter();
  const { user, loading } = useAuth();
  const { items, clear, total } = useCart();
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!loading && !user) router.replace('/login?next=/checkout');
  }, [loading, user, router]);

  const handleSubmit = async () => {
    if (!user) return;
    if (items.length === 0) {
      setError('Cart is empty.');
      return;
    }
    setSubmitting(true);
    setError(null);
    const { db } = getFirebase();
    const reserved: { productId: string; qty: number }[] = [];

    try {
      for (const it of items) {
        const stockRef = child(ref(db, 'products'), `${it.productId}/stock`);
        const ok = await decrementStock(stockRef, it.qty);
        if (!ok) {
          throw new Error(`Not enough stock for ${it.name}`);
        }
        reserved.push({ productId: it.productId, qty: it.qty });
      }

      await createOrder({
        user,
        items,
        total,
        deliveryAddress: {},
      });

      clear();
      router.push('/orders');
    } catch (e) {
      setError(e instanceof Error ? e.message : 'Checkout failed.');
      // rollback attempts
      for (const r of reserved) {
        try {
          const stockRef = child(ref(db, 'products'), `${r.productId}/stock`);
          await decrementStock(stockRef, -r.qty); // may be blocked by rules; best-effort rollback
        } catch {
          // ignore rollback errors
        }
      }
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Checkout</h1>
      <div className="rounded-lg border bg-white p-4 shadow-sm">
        <p className="mb-2 text-sm text-gray-700">Items: {items.length}</p>
        <p className="text-lg font-semibold text-indigo-700">Total: {total.toFixed(2)} QAR</p>
        {error && <p className="mt-2 text-sm text-red-600">{error}</p>}
        <button
          onClick={handleSubmit}
          disabled={submitting || items.length === 0}
          className="mt-4 w-full rounded-md bg-indigo-600 px-4 py-2 text-white hover:bg-indigo-700 disabled:cursor-not-allowed disabled:bg-gray-300"
        >
          {submitting ? 'Processing...' : 'Place order'}
        </button>
      </div>
    </div>
  );
}
