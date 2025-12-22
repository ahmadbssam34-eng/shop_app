'use client';

import { useEffect } from 'react';
import { useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth-context';
import { AdminProductForm } from '@/components/admin-product-form';

export default function AdminProductNewPage() {
  const { user, isAdmin, loading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!loading && (!user || !isAdmin)) router.replace('/login?next=/admin/products/new');
  }, [loading, user, isAdmin, router]);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Add Product</h1>
      <AdminProductForm />
    </div>
  );
}
