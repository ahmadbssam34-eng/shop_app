'use client';

import Link from 'next/link';
import { useAuth } from '@/lib/auth-context';

export function Navbar() {
  const { user, isAdmin, logout } = useAuth();
  return (
    <header className="border-b bg-white">
      <nav className="mx-auto flex max-w-6xl items-center justify-between px-4 py-3">
        <div className="flex items-center gap-4">
          <Link href="/" className="text-lg font-bold text-indigo-700">
            HERZ Shop (Web)
          </Link>
          <Link href="/" className="text-sm text-gray-700 hover:text-indigo-700">
            Products
          </Link>
          {user && (
            <Link href="/orders" className="text-sm text-gray-700 hover:text-indigo-700">
              My Orders
            </Link>
          )}
          {isAdmin && (
            <Link href="/admin" className="text-sm text-gray-700 hover:text-indigo-700">
              Admin
            </Link>
          )}
        </div>
        <div className="flex items-center gap-3">
          {user ? (
            <>
              <span className="text-sm text-gray-600">{user.email ?? user.phoneNumber ?? 'User'}</span>
              <button
                onClick={logout}
                className="rounded-md border border-gray-300 px-3 py-1 text-sm font-medium text-gray-700 hover:bg-gray-50"
              >
                Logout
              </button>
            </>
          ) : (
            <>
              <Link
                href="/login"
                className="rounded-md border border-gray-300 px-3 py-1 text-sm font-medium text-gray-700 hover:bg-gray-50"
              >
                Login
              </Link>
              <Link
                href="/signup"
                className="rounded-md bg-indigo-600 px-3 py-1 text-sm font-medium text-white hover:bg-indigo-700"
              >
                Sign up
              </Link>
            </>
          )}
        </div>
      </nav>
    </header>
  );
}
