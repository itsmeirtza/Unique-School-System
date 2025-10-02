'use client';

import { useAuth } from '@/lib/contexts/AuthContext';
import SplashScreen from '@/components/SplashScreen';
import Dashboard from '@/components/Dashboard';

export default function Home() {
  const { user, userData, loading } = useAuth();

  if (loading) {
    return <div className="flex items-center justify-center min-h-screen">Loading...</div>;
  }

  if (user && userData) {
    return <Dashboard />;
  }

  return <SplashScreen />;
}
