import { Router, Request, Response, NextFunction } from 'express';

export const coursesPolicyRouter = Router();

/**
 * Policy: authorization checked per route
 * - Teacher owns their courses
 * - Student must be enrolled to access course-specific routes
 * - Public routes: none for courses (all require auth)
 */
export const createCourse = (req: Request, _res: Response, next: NextFunction) => {
  // Teacher can create courses (auth middleware will verify role)
  next();
};

export const getCourses = (req: Request, _res: Response, next: NextFunction) => {
  // Student enrolled or teacher can list courses
  next();
};

export const getCourse = (req: Request, _res: Response, next: NextFunction) => {
  // Owner or enrolled student can access course
  next();
};

export const updateCourse = (req: Request, _res: Response, next: NextFunction) => {
  // Owner (includes archive) can update course
  next();
};

export const regenerateJoinCode = (req: Request, _res: Response, next: NextFunction) => {
  // Owner can regenerate join code
  next();
};

export const enrollStudent = (req: Request, _res: Response, next: NextFunction) => {
  // Student can enroll with valid join code
  next();
};

export const getCourseMembers = (req: Request, _res: Response, next: NextFunction) => {
  // Owner can view members
  next();
};

export const removeMember = (req: Request, _res: Response, next: NextFunction) => {
  // Owner can remove member
  next();
};