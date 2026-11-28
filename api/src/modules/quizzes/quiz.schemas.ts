import { z } from 'zod';

export const createQuizSchema = z.object({
  title: z.string().min(1).max(200, 'Title must be between 1 and 200 characters'),
  instructions: z.string().optional(),
  status: z.enum(['draft', 'published', 'closed', 'deliberated', 'released']),
  opensAt: z.date().optional(),
  closesAt: z.date().optional(),
  durationSec: z.number().int().positive().optional(),
  settings: z.object({
    maxAttempts: z.number().int().min(1),
    focus: z.object({
      mode: z.enum(['warning', 'strict', 'observe']),
      maxExits: z.number().int().min(1).default(3),
      maxAbsenceSec: z.number().int().min(1).default(10),
    }),
    release: z.enum(['immediate', 'after_deliberation']),
    showAnswers: z.enum(['after_close', 'never']),
    leaderboard: z.boolean().default(false),
    shuffleQuestions: z.boolean().default(false),
    shuffleOptions: z.boolean().default(false),
  }),
});

export type CreateQuizInput = z.infer<typeof createQuizSchema>;
export type UpdateQuizInput = z.infer<typeof createQuizSchema>;