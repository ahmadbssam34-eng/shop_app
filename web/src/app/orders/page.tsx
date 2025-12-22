'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth-context';
import { useOrders } from '@/lib/rtdb';

export default function OrdersPage() {
  const { user, loading } = useAuth();
  const router = useRouter();
  const orders = useOrders(user?.uid);

  useEffect(() => {
    if (!loading && !user) router.replace('/login?next=/orders');
  }, [loading, user, router]);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">My Orders</h1>
      {orders.length === 0 ? (
        <p>No orders yet.</p>
      ) : (
        <div className="space-y-3">
          {orders.map((o) => (
            <div key={o.id} className="rounded-lg border bg-white p-4 shadow-sm">
              <div className="flex items-center justify-between">
                <div className="font-semibold">Order #{o.id}</div>
                <div className="text-sm text-gray-600">{o.status}</div>
              </div>
              <div className="mt-2 space-y-1">
                {o.items.map((it) => (
                  <div key={it.productId} className="flex justify-between text-sm text-gray-700">
                    <span>
                      {it.name} × {it.qty}
                    </span>
                    <span>{(it.qty * it.price).toFixed(2)} QAR</span>
                  </div>
                ))}
              </div>
              <div className="mt-2 text-sm text-gray-500">
                Total: <span className="font-semibold text-indigo-700">{o.total.toFixed(2)} QAR</span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}
