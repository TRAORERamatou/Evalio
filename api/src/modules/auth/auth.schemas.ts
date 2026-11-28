import { z } from 'zod';

export const registerSchema = z.object({
  firstName: z.string().min(1).max(100, 'First name must be between 1 and 100 characters'),
  lastName: z.string().min(1).max(100, 'Last name must be between 1 and 100 characters'),
  email: z.string().email('Invalid email address').toLowerCase(),
  password: z
    .string()
    .min(8, 'Password must be at least 8 characters')
    .max(128, 'Password must be at most 128 characters'),
});

export const loginSchema = z.object({
  email: z.string().email('Invalid email address').toLowerCase(),
  password: z.string().min(1, 'Password is required'),
});

export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;