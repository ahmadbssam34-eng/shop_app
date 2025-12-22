'use client';

import { useEffect } from 'react';
import { useParams, useRouter } from 'next/navigation';
import { useAuth } from '@/lib/auth-context';
import { AdminProductForm } from '@/components/admin-product-form';

export default function AdminProductEditPage() {
  const params = useParams<{ id: string }>();
  const { user, isAdmin, loading } = useAuth();
  const router = useRouter();

  useEffect(() => {
    if (!loading && (!user || !isAdmin)) router.replace(`/login?next=/admin/products/${params?.id ?? ''}`);
  }, [loading, user, isAdmin, router, params?.id]);

  return (
    <div className="space-y-4">
      <h1 className="text-2xl font-bold">Edit Product</h1>
      <AdminProductForm productId={params?.id} />
    </div>
  );
}
