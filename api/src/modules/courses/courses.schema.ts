import { z } from 'zod';

export const createCourseBodySchema = z.object({
  title: z.string().min(1, 'Title is required'),
  code: z.string().min(1, 'Code is required'),
  description: z.string().optional(),
});

export type CreateCourseBody = z.infer<typeof createCourseBodySchema>;

export const joinCourseBodySchema = z.object({
  joinCode: z.string().min(1, 'Join code is required').length(8, 'Join code must be 8 characters'),
});

export type JoinCourseBody = z.infer<typeof joinCourseBodySchema>;

export const enrollStudentBodySchema = z.object({
  joinCode: z.string().min(1, 'Join code is required').length(8, 'Join code must be 8 characters'),
});

export type EnrollStudentBody = z.infer<typeof enrollStudentBodySchema>;