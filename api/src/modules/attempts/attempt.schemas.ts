import { z } from 'zod';

export const submitAnswerSchema = z.object({
  selectedOptionIds: z.array(z.string()).optional(),
  text: z.string().optional(),
  clientSeq: z.number().int().optional(),
});

export type SubmitAnswerInput = z.infer<typeof submitAnswerSchema>;

export const saveAnswerSchema = z.object({
  selectedOptionIds: z.array(z.string()).optional(),
  text: z.string(),
  clientSeq: z.number().int(),
});

export type SaveAnswerInput = z.infer<typeof saveAnswerSchema>;

export const createAttemptSchema = z.object({
  clientEventId: z.string().uuid('Invalid client event ID format'),
  leftAt: z.date(),
  durationMs: z.number().int().positive(),
});

export type CreateAttemptInput = z.infer<typeof createAttemptSchema>;

export const heartbeatSchema = z.object({
  clientEventId: z.string().uuid('Invalid client event ID format'),
});

export type HeartbeatInput = z.infer<typeof heartbeatSchema>;