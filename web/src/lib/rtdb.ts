'use client';

import { useEffect, useState } from 'react';
import {
  ref,
  onValue,
  runTransaction,
  push,
  set,
  get,
  child,
  type DatabaseReference,
} from 'firebase/database';
import { getFirebase } from './firebase';
import { type User } from 'firebase/auth';

export type Product = {
  id: string;
  name: string;
  name_en?: string;
  desc?: string;
  desc_en?: string;
  descExtra?: string;
  descExtra_en?: string;
  price: number;
  stock?: number | null;
  imageUrl?: string;
  gallery?: string[];
  beforeAfter?: { beforeUrl?: string; afterUrl?: string };
};

export type OrderItem = {
  productId: string;
  name: string;
  qty: number;
  price: number;
};

export type Order = {
  id: string;
  status: string;
  total: number;
  createdAt?: number;
  items: OrderItem[];
  deliveryAddress?: Record<string, unknown>;
};

const paths = {
  products: 'products',
  orders: 'orders',
  purchases: 'purchases',
};

export function useProducts() {
  const { db } = getFirebase();
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const productsRef = ref(db, paths.products);
    const unsub = onValue(productsRef, (snap) => {
      const val = snap.val() ?? {};
      const parsed: Product[] = Object.entries(val).flatMap(([id, data]) => {
        if (typeof data !== 'object' || data === null) return [];
        const m = data as Record<string, unknown>;
        return [
          {
            id,
            name: String(m.name ?? ''),
            name_en: m.name_en ? String(m.name_en) : undefined,
            desc: m.desc ? String(m.desc) : undefined,
            desc_en: m.desc_en ? String(m.desc_en) : undefined,
            descExtra: m.descExtra ? String(m.descExtra) : undefined,
            descExtra_en: m.descExtra_en ? String(m.descExtra_en) : undefined,
            price: Number(m.price ?? 0),
            stock: m.stock === undefined || m.stock === null ? null : Number(m.stock),
            imageUrl: m.imageUrl ? String(m.imageUrl) : undefined,
            gallery: Array.isArray(m.gallery) ? (m.gallery as string[]) : [],
            beforeAfter: m.beforeAfter as Product['beforeAfter'],
          },
        ];
      });
      setProducts(parsed);
      setLoading(false);
    });
    return () => unsub();
  }, [db]);

  return { products, loading };
}

export async function decrementStock(refForStock: DatabaseReference, qty: number) {
  const res = await runTransaction(refForStock, (current) => {
    const curr = typeof current === 'number' ? current : Number(current ?? 0);
    if (Number.isNaN(curr) || curr < qty) return;
    return curr - qty;
  });
  return res.committed;
}

export async function createOrder({
  user,
  items,
  total,
  deliveryAddress,
}: {
  user: User;
  items: OrderItem[];
  total: number;
  deliveryAddress?: Record<string, string>;
}) {
  const { db } = getFirebase();
  const orderRef = push(ref(db, `${paths.orders}/${user.uid}`));
  await set(orderRef, {
    status: 'pending',
    total,
    items,
    deliveryAddress: deliveryAddress ?? {},
    createdAt: Date.now(),
  });
  const purchasesRef = ref(db, `${paths.purchases}/${user.uid}`);
  for (const item of items) {
    await set(child(purchasesRef, item.productId), true);
  }
  return orderRef.key;
}

export async function getProductOnce(id: string): Promise<Product | null> {
  const { db } = getFirebase();
  const snap = await get(ref(db, `${paths.products}/${id}`));
  const m = snap.val();
  if (!m) return null;
  return {
    id,
    name: String(m.name ?? ''),
    name_en: m.name_en ? String(m.name_en) : undefined,
    desc: m.desc ? String(m.desc) : undefined,
    desc_en: m.desc_en ? String(m.desc_en) : undefined,
    descExtra: m.descExtra ? String(m.descExtra) : undefined,
    descExtra_en: m.descExtra_en ? String(m.descExtra_en) : undefined,
    price: Number(m.price ?? 0),
    stock: m.stock === undefined || m.stock === null ? null : Number(m.stock),
    imageUrl: m.imageUrl ? String(m.imageUrl) : undefined,
    gallery: Array.isArray(m.gallery) ? (m.gallery as string[]) : [],
    beforeAfter: m.beforeAfter as Product['beforeAfter'],
  };
}

export function useOrders(uid: string | undefined) {
  const { db } = getFirebase();
  const [orders, setOrders] = useState<Order[]>([]);
  useEffect(() => {
    if (!uid) return;
    const ordersRef = ref(db, `${paths.orders}/${uid}`);
    const unsub = onValue(ordersRef, (snap) => {
      const val = snap.val() ?? {};
      const parsed: Order[] = Object.entries(val).flatMap(([id, data]) => {
        if (typeof data !== 'object' || data === null) return [];
        const m = data as Record<string, unknown>;
        const items = Array.isArray(m.items) ? (m.items as OrderItem[]) : Object.values(m.items ?? {});
        return [
          {
            id,
            status: String(m.status ?? ''),
            total: Number(m.total ?? 0),
            createdAt: typeof m.createdAt === 'number' ? m.createdAt : undefined,
            items: items.map((it) => ({
              productId: String((it as OrderItem).productId ?? ''),
              name: String((it as OrderItem).name ?? ''),
              qty: Number((it as OrderItem).qty ?? 0),
              price: Number((it as OrderItem).price ?? 0),
            })),
            deliveryAddress: (m.deliveryAddress as Record<string, unknown>) ?? {},
          },
        ];
      });
      setOrders(parsed);
    });
    return () => unsub();
  }, [db, uid]);
  return orders;
}
