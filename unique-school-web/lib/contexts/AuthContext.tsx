'use client';

import React, { createContext, useContext, useEffect, useState } from 'react';
import { 
  User,
  signInWithEmailAndPassword,
  createUserWithEmailAndPassword,
  signOut,
  onAuthStateChanged,
  sendPasswordResetEmail
} from 'firebase/auth';
import { doc, setDoc, getDoc } from 'firebase/firestore';
import { auth, db } from '@/lib/firebase';

interface UserData {
  uid: string;
  email: string;
  name: string;
  role: 'parent' | 'teacher';
}

interface AuthContextType {
  user: User | null;
  userData: UserData | null;
  loading: boolean;
  error: string;
  signIn: (email: string, password: string, role: string) => Promise<boolean>;
  signUp: (email: string, password: string, role: string, additionalData: Record<string, unknown>) => Promise<boolean>;
  logout: () => Promise<void>;
  resetPassword: (email: string) => Promise<boolean>;
  clearError: () => void;
}

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const AuthProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [userData, setUserData] = useState<UserData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');

  useEffect(() => {
    if (typeof window === 'undefined' || !auth) {
      setLoading(false);
      return;
    }
    
    const unsubscribe = onAuthStateChanged(auth, async (user) => {
      if (user) {
        setUser(user);
        // Fetch user data from Firestore
        if (db) {
          const userDoc = await getDoc(doc(db, 'users', user.uid));
          if (userDoc.exists()) {
            setUserData(userDoc.data() as UserData);
          }
        }
      } else {
        setUser(null);
        setUserData(null);
      }
      setLoading(false);
    });

    return () => unsubscribe();
  }, []);

  const signIn = async (email: string, password: string, role: string): Promise<boolean> => {
    if (!auth || !db) {
      setError('Authentication not initialized');
      return false;
    }
    
    try {
      setLoading(true);
      setError('');
      const result = await signInWithEmailAndPassword(auth, email, password);
      
      // Verify role
      const userDoc = await getDoc(doc(db, 'users', result.user.uid));
      if (userDoc.exists() && userDoc.data()?.role !== role) {
        setError(`Please use the ${userDoc.data()?.role} portal to sign in.`);
        await signOut(auth);
        return false;
      }
      
      return true;
    } catch (error: unknown) {
      setError(error instanceof Error ? error.message : 'Sign in failed');
      return false;
    } finally {
      setLoading(false);
    }
  };

  const signUp = async (email: string, password: string, role: string, additionalData: Record<string, unknown>): Promise<boolean> => {
    if (!auth || !db) {
      setError('Authentication not initialized');
      return false;
    }
    
    try {
      setLoading(true);
      setError('');
      const result = await createUserWithEmailAndPassword(auth, email, password);
      
      // Save user data to Firestore
      await setDoc(doc(db, 'users', result.user.uid), {
        uid: result.user.uid,
        email: result.user.email,
        role,
        ...additionalData,
        createdAt: new Date().toISOString(),
      });
      
      return true;
    } catch (error: unknown) {
      setError(error instanceof Error ? error.message : 'Sign up failed');
      return false;
    } finally {
      setLoading(false);
    }
  };

  const logout = async (): Promise<void> => {
    if (!auth) {
      setError('Authentication not initialized');
      return;
    }
    
    try {
      await signOut(auth);
    } catch (error: unknown) {
      setError(error instanceof Error ? error.message : 'Logout failed');
    }
  };

  const resetPassword = async (email: string): Promise<boolean> => {
    if (!auth) {
      setError('Authentication not initialized');
      return false;
    }
    
    try {
      await sendPasswordResetEmail(auth, email);
      return true;
    } catch (error: unknown) {
      setError(error instanceof Error ? error.message : 'Password reset failed');
      return false;
    }
  };

  const clearError = () => {
    setError('');
  };

  const value = {
    user,
    userData,
    loading,
    error,
    signIn,
    signUp,
    logout,
    resetPassword,
    clearError,
  };

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
};

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};