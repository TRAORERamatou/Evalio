import express from 'express';
import helmet from 'helmet';
import { errorHandler, notFound } from './core/errors.js';
import { healthRouter } from './modules/health/health.routes.js';
import { authRouter } from './modules/auth/auth.routes.js';
import { coursesRouter } from './modules/courses/courses.routes.js';

export function createApp() {
  const app = express();
  app.use(helmet());
  app.use(express.json({ limit: '100kb' }));
  app.use('/api/v1', healthRouter);
  app.use('/api/v1', authRouter);
  app.use('/api/v1', coursesRouter);
  app.use(notFound);
  app.use(errorHandler);
  return app;
}
