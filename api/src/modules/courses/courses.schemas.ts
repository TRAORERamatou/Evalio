import { z } from 'zod';

export const createCourseSchema = z.object({
  title: z.string().min(1).max(200, 'Title must be between 1 and 200 characters'),
  description: z.string().optional(),
  code: z.string().optional(),
});

export const updateCourseSchema = z.object({
  title: z.string().min(1).max(200, 'Title must be between 1 and 200 characters').optional(),
  description: z.string().optional(),
  code: z.string().optional(),
});

export type CreateCourseInput = z.infer<typeof createCourseSchema>;
export type UpdateCourseInput = z.infer<typeof updateCourseSchema>;