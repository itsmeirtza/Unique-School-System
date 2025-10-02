'use client';

import { useState, useEffect } from 'react';
import { motion } from 'framer-motion';
import { School, Users, ArrowRight, BookOpen } from 'lucide-react';
import RoleDialog from './RoleDialog';

export default function SplashScreen() {
  const [showDialog, setShowDialog] = useState(false);

  useEffect(() => {
    const timer = setTimeout(() => {
      setShowDialog(true);
    }, 2500);

    return () => clearTimeout(timer);
  }, []);

  return (
    <div className="min-h-screen bg-gradient-to-br from-white to-blue-50 dark:from-gray-900 dark:to-gray-800 flex items-center justify-center">
      <div className="text-center">
        <motion.div
          initial={{ scale: 0, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          transition={{
            duration: 1.2,
            ease: "easeOut",
            scale: { type: "spring", stiffness: 100, damping: 10 }
          }}
          className="mb-8"
        >
          <div className="relative w-40 h-40 mx-auto mb-6">
            <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-blue-600 rounded-full shadow-2xl animate-pulse" />
            <div className="absolute inset-4 bg-white dark:bg-gray-800 rounded-full flex items-center justify-center">
              <School className="w-20 h-20 text-blue-500" />
            </div>
            <div className="absolute -top-2 -right-2 w-8 h-8 bg-yellow-400 rounded-full animate-bounce" />
            <div className="absolute -bottom-2 -left-2 w-6 h-6 bg-green-400 rounded-full animate-bounce delay-300" />
          </div>
        </motion.div>

        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6, duration: 0.8 }}
        >
          <h1 className="text-4xl md:text-6xl font-bold bg-gradient-to-r from-blue-600 to-blue-800 bg-clip-text text-transparent mb-4">
            Unique School System
          </h1>
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1.0, duration: 0.8 }}
          className="mb-8"
        >
          <p className="text-xl text-gray-600 dark:text-gray-300 font-medium tracking-wide">
            Smart. Simple. Stunning.
          </p>
        </motion.div>

        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 1.4, duration: 0.8 }}
        >
          <div className="w-8 h-8 border-4 border-blue-500 border-t-transparent rounded-full animate-spin mx-auto" />
        </motion.div>
      </div>

      {showDialog && <RoleDialog onClose={() => setShowDialog(false)} />}
    </div>
  );
}