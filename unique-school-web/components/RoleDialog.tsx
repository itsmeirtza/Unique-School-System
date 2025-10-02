'use client';

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import { Users, GraduationCap, ArrowRight, X } from 'lucide-react';
import AuthScreen from './AuthScreen';

interface RoleDialogProps {
  onClose: () => void;
}

export default function RoleDialog({ onClose }: RoleDialogProps) {
  const [selectedRole, setSelectedRole] = useState<string | null>(null);

  if (selectedRole) {
    return <AuthScreen role={selectedRole} onClose={onClose} />;
  }

  return (
    <AnimatePresence>
      <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
        <motion.div
          initial={{ scale: 0.9, opacity: 0 }}
          animate={{ scale: 1, opacity: 1 }}
          exit={{ scale: 0.9, opacity: 0 }}
          className="bg-white dark:bg-gray-800 rounded-2xl p-6 max-w-md w-full shadow-2xl"
        >
          <div className="flex items-center justify-between mb-6">
            <div className="flex items-center space-x-3">
              <div className="w-8 h-8 bg-blue-100 dark:bg-blue-900 rounded-full flex items-center justify-center">
                <Users className="w-4 h-4 text-blue-600" />
              </div>
              <h2 className="text-2xl font-bold text-gray-800 dark:text-white">
                Welcome!
              </h2>
            </div>
            <button
              onClick={onClose}
              className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
            >
              <X className="w-6 h-6" />
            </button>
          </div>

          <p className="text-gray-600 dark:text-gray-300 mb-6">
            Please select your role to continue:
          </p>

          <div className="space-y-3">
            <button
              onClick={() => setSelectedRole('parent')}
              className="w-full p-4 border-2 border-gray-200 dark:border-gray-600 rounded-xl hover:border-blue-500 dark:hover:border-blue-400 transition-colors group"
            >
              <div className="flex items-center space-x-4">
                <div className="w-12 h-12 bg-blue-50 dark:bg-blue-900 rounded-xl flex items-center justify-center group-hover:bg-blue-100 dark:group-hover:bg-blue-800 transition-colors">
                  <Users className="w-6 h-6 text-blue-600" />
                </div>
                <div className="flex-1 text-left">
                  <h3 className="font-semibold text-gray-800 dark:text-white">Parent</h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400">Track your child's progress</p>
                </div>
                <ArrowRight className="w-5 h-5 text-gray-400 group-hover:text-blue-500 transition-colors" />
              </div>
            </button>

            <button
              onClick={() => setSelectedRole('teacher')}
              className="w-full p-4 border-2 border-gray-200 dark:border-gray-600 rounded-xl hover:border-blue-500 dark:hover:border-blue-400 transition-colors group"
            >
              <div className="flex items-center space-x-4">
                <div className="w-12 h-12 bg-blue-50 dark:bg-blue-900 rounded-xl flex items-center justify-center group-hover:bg-blue-100 dark:group-hover:bg-blue-800 transition-colors">
                  <GraduationCap className="w-6 h-6 text-blue-600" />
                </div>
                <div className="flex-1 text-left">
                  <h3 className="font-semibold text-gray-800 dark:text-white">Teacher</h3>
                  <p className="text-sm text-gray-500 dark:text-gray-400">Manage classes and students</p>
                </div>
                <ArrowRight className="w-5 h-5 text-gray-400 group-hover:text-blue-500 transition-colors" />
              </div>
            </button>
          </div>
        </motion.div>
      </div>
    </AnimatePresence>
  );
}