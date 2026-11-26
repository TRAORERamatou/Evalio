import { randomUUID } from 'node:crypto';
import type { ErrorRequestHandler, RequestHandler } from 'express';

export interface FieldError {
  field: string;
  message: string;
}

export class AppError extends Error {
  constructor(
    public readonly status: number,
    public readonly code: string,
    message: string,
    public readonly details: FieldError[] = [],
  ) {
    super(message);
  }
}

export const notFound: RequestHandler = () => {
  throw new AppError(404, 'NOT_FOUND', 'Resource not found');
};

const bodyParserCodes: Record<number, string> = {
  400: 'BAD_REQUEST',
  413: 'PAYLOAD_TOO_LARGE',
};

export const errorHandler: ErrorRequestHandler = (err, _req, res, _next) => {
  const requestId = randomUUID();
  let status = 500;
  let code = 'INTERNAL_ERROR';
  let message = 'Unexpected error';
  let details: FieldError[] = [];

  if (err instanceof AppError) {
    ({ status, code, message, details } = err);
  } else if (typeof err?.status === 'number' && bodyParserCodes[err.status]) {
    status = err.status;
    code = bodyParserCodes[err.status]!;
    message = 'Invalid request body';
  } else {
    console.error(requestId, err);
  }

  res.status(status).json({ error: { code, message, details, requestId } });
};
