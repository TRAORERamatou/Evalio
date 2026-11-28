import { Router, Request, Response, NextFunction } from 'express';
import {
  createCourseService,
  getCoursesService,
  getCourseService,
  updateCourseService,
  regenerateJoinCodeService,
  enrollStudentService,
  getCourseMembersService,
  removeMemberService,
} from './courses.service.js';

export const coursesRouter = Router();

// POST /api/v1/courses
coursesRouter.post('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await createCourseService(req, res, next);
  } catch (err) {
    next(err);
  }
});

// GET /api/v1/courses
coursesRouter.get('/', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await getCoursesService(req, res, next);
  } catch (err) {
    next(err);
  }
});

// GET /api/v1/courses/:id
coursesRouter.get('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await getCourseService(req, res, next);
  } catch (err) {
    next(err);
  }
});

// PATCH /api/v1/courses/:id
coursesRouter.patch('/:id', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await updateCourseService(req, res, next);
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/courses/:id/join-code
coursesRouter.post('/:id/join-code', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await regenerateJoinCodeService(req, res, next);
  } catch (err) {
    next(err);
  }
});

// POST /api/v1/enrollments
coursesRouter.post('/enrollments', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await enrollStudentService(req, res, next);
  } catch (err) {
    next(err);
  }
});

// GET /api/v1/courses/:id/members
coursesRouter.get('/:id/members', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await getCourseMembersService(req, res, next);
  } catch (err) {
    next(err);
  }
});

// DELETE /api/v1/courses/:id/members/:studentId
coursesRouter.delete('/:id/members/:studentId', async (req: Request, res: Response, next: NextFunction) => {
  try {
    await removeMemberService(req, res, next);
  } catch (err) {
    next(err);
  }
});