'use client';

import { useAuth } from '@/lib/contexts/AuthContext';
import { useState, useEffect } from 'react';
import SplashScreen from '@/components/SplashScreen';
import Dashboard from '@/components/Dashboard';
import Loading from '@/components/Loading';

export default function Home() {
  const [mounted, setMounted] = useState(false);
  const { user, userData, loading } = useAuth();

  useEffect(() => {
    setMounted(true);
  }, []);

  // Don't render anything until client-side hydration is complete
  if (!mounted) {
    return <Loading />;
  }

  if (loading) {
    return <Loading />;
  }

  if (user && userData) {
    return <Dashboard />;
  }

  return <SplashScreen />;
}
