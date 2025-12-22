'use client';

import { createContext, useContext, useEffect, useMemo, useState, type PropsWithChildren } from 'react';
import { Product } from './rtdb';

export type CartItem = {
  productId: string;
  name: string;
  price: number;
  qty: number;
  stock?: number | null;
};

type CartContextShape = {
  items: CartItem[];
  add: (product: Product, qty?: number) => void;
  remove: (productId: string) => void;
  clear: () => void;
  updateQty: (productId: string, qty: number) => void;
  total: number;
  totalQty: number;
};

const STORAGE_KEY = 'herz-cart';
const CartContext = createContext<CartContextShape | undefined>(undefined);

function loadCart(): CartItem[] {
  if (typeof window === 'undefined') return [];
  try {
    const raw = window.localStorage.getItem(STORAGE_KEY);
    if (!raw) return [];
    const parsed = JSON.parse(raw);
    if (!Array.isArray(parsed)) return [];
    return parsed;
  } catch {
    return [];
  }
}

export function CartProvider({ children }: PropsWithChildren) {
  const [items, setItems] = useState<CartItem[]>([]);

  useEffect(() => {
    setItems(loadCart());
  }, []);

  useEffect(() => {
    if (typeof window === 'undefined') return;
    window.localStorage.setItem(STORAGE_KEY, JSON.stringify(items));
  }, [items]);

  useEffect(() => {
    const handler = () => setItems(loadCart());
    if (typeof window !== 'undefined') {
      window.addEventListener('storage', handler);
      return () => window.removeEventListener('storage', handler);
    }
  }, []);

  const add = (product: Product, qty = 1) => {
    setItems((prev) => {
      const existing = prev.find((p) => p.productId === product.id);
      if (existing) {
        return prev.map((p) =>
          p.productId === product.id ? { ...p, qty: p.qty + qty, stock: product.stock } : p,
        );
      }
      return [
        ...prev,
        {
          productId: product.id,
          name: product.name,
          price: product.price,
          qty,
          stock: product.stock,
        },
      ];
    });
  };

  const remove = (productId: string) => setItems((prev) => prev.filter((p) => p.productId !== productId));

  const clear = () => setItems([]);

  const updateQty = (productId: string, qty: number) =>
    setItems((prev) => prev.map((p) => (p.productId === productId ? { ...p, qty } : p)));

  const total = useMemo(() => items.reduce((sum, it) => sum + it.qty * it.price, 0), [items]);
  const totalQty = useMemo(() => items.reduce((sum, it) => sum + it.qty, 0), [items]);

  const value: CartContextShape = { items, add, remove, clear, updateQty, total, totalQty };

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>;
}

export function useCart() {
  const ctx = useContext(CartContext);
  if (!ctx) throw new Error('useCart must be used within CartProvider');
  return ctx;
}
