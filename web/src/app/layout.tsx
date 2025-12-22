import type { Metadata } from 'next';
import { Inter } from 'next/font/google';
import './globals.css';
import { AuthProvider } from '@/lib/auth-context';
import { Navbar } from '@/components/navbar';
import { CartProvider } from '@/lib/cart';

const inter = Inter({ subsets: ['latin'] });

export const metadata: Metadata = {
  title: 'HERZ Shop Web',
  description: 'Web storefront for HERZ shop using Firebase RTDB.',
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <AuthProvider>
          <CartProvider>
            <Navbar />
            <main className="mx-auto max-w-6xl px-4 py-6">{children}</main>
          </CartProvider>
        </AuthProvider>
      </body>
    </html>
  );
}
