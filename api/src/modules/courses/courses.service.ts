import { Request, Response, NextFunction } from 'express';
import { Course, Enrollment } from './courses.model';
import { createCourseBodySchema, joinCourseBodySchema, enrollStudentBodySchema } from './courses.schema';

export async function createCourseService(req: Request, res: Response, _next: NextFunction) {
  const result = createCourseBodySchema.safeParse(req.body);
  if (!result.success) {
    return res.status(422).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Invalid input',
        details: result.error.issues.map((i) => ({ field: i.path.join('.'), message: i.message })),
      },
    });
  }

  const { title, code, description } = result.data;

  // Check if course code already exists
  const existingCourse = await Course.findOne({ code });
  if (existingCourse) {
    return res.status(409).json({
      error: {
        code: 'CONFLICT',
        message: 'Course code already exists',
        details: [{ field: 'code', message: 'Course code already exists' }],
      },
    });
  }

  // Create course - teacherId will be set by auth middleware
  const course = await Course.create({
    title,
    code,
    description,
    isArchived: false,
  });

  return res.status(201).json({
    data: course,
  });
}

export async function getCoursesService(req: Request, res: Response, _next: NextFunction) {
  const page = Number(req.query.page) || 1;
  const limit = Math.min(Number(req.query.limit) || 20, 50);
  const search = (req.query.search as string) || '';

  const filter: any = {
    isArchived: { $ne: true },
  };

  if (search) {
    filter.$or = [
      { title: { $regex: search, $options: 'i' } },
      { code: { $regex: search, $options: 'i' } },
    ];
  }

  const courses = await Course.find(filter)
    .sort({ createdAt: -1 })
    .skip((page - 1) * limit)
    .limit(limit);

  const total = await Course.countDocuments(filter);

  return res.status(200).json({
    data: courses,
    meta: {
      page,
      limit,
      total,
    },
  });
}

export async function getCourseService(req: Request, res: Response, _next: NextFunction) {
  const { courseId } = req.params;

  const course = await Course.findById(courseId);
  if (!course) {
    return res.status(404).json({
      error: {
        code: 'NOT_FOUND',
        message: 'Course not found',
        details: [{ field: 'courseId', message: 'Course not found' }],
      },
    });
  }

  return res.status(200).json({
    data: course,
  });
}

export async function updateCourseService(req: Request, res: Response, _next: NextFunction) {
  const { courseId } = req.params;
  const result = createCourseBodySchema.safeParse(req.body);
  if (!result.success) {
    return res.status(422).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Invalid input',
        details: result.error.issues.map((i) => ({ field: i.path.join('.'), message: i.message })),
      },
    });
  }

  const { title, code } = result.data;

  // Check if new code already exists (and is not the same course)
  const existingCourse = await Course.findOne({
    code,
    _id: { $ne: courseId },
  });
  if (existingCourse) {
    return res.status(409).json({
      error: {
        code: 'CONFLICT',
        message: 'Course code already exists',
        details: [{ field: 'code', message: 'Course code already exists' }],
      },
    });
  }

  const course = await Course.findByIdAndUpdate(
    courseId,
    { title, code },
    { new: true, runValidators: true }
  );

  if (!course) {
    return res.status(404).json({
      error: {
        code: 'NOT_FOUND',
        message: 'Course not found',
        details: [{ field: 'courseId', message: 'Course not found' }],
      },
    });
  }

  return res.status(200).json({
    data: course,
  });
}

export async function regenerateJoinCodeService(req: Request, res: Response, _next: NextFunction) {
  const { courseId } = req.params;

  const course = await Course.findById(courseId);
  if (!course) {
    return res.status(404).json({
      error: {
        code: 'NOT_FOUND',
        message: 'Course not found',
        details: [{ field: 'courseId', message: 'Course not found' }],
      },
    });
  }

  // Generate new 8-character join code
  const newCode = Math.random().toString(36).substring(2, 10).toUpperCase();
  course.joinCode = newCode;
  await course.save();

  return res.status(200).json({
    data: { joinCode: newCode },
  });
}

export async function enrollStudentService(req: Request, res: Response, _next: NextFunction) {
  const result = enrollStudentBodySchema.safeParse(req.body);
  if (!result.success) {
    return res.status(422).json({
      error: {
        code: 'VALIDATION_ERROR',
        message: 'Invalid input',
        details: result.error.issues.map((i) => ({ field: i.path.join('.'), message: i.message })),
      },
    });
  }

  const { joinCode } = result.data;

  // Find course by join code
  const course = await Course.findOne({ joinCode });
  if (!course) {
    return res.status(404).json({
      error: {
        code: 'NOT_FOUND',
        message: 'Invalid join code',
        details: [{ field: 'joinCode', message: 'Invalid join code' }],
      },
    });
  }

  // Check if course is archived
  if (course.isArchived) {
    return res.status(409).json({
      error: {
        code: 'STATE_ERROR',
        message: 'Course is archived',
        details: [{ field: 'course', message: 'Course is archived' }],
      },
    });
  }

  // Check if student already enrolled
  const existingEnrollment = await Enrollment.findOne({
    courseId: course._id,
    studentId: req.user?.id,
  });

  if (existingEnrollment && existingEnrollment.status === 'active') {
    return res.status(409).json({
      error: {
        code: 'STATE_ERROR',
        message: 'Already enrolled in this course',
        details: [{ field: 'student', message: 'Already enrolled in this course' }],
      },
    });
  }

  // Enroll student
  const enrollment = await Enrollment.create({
    courseId: course._id,
    studentId: req.user?.id,
    status: 'active',
  });

  return res.status(201).json({
    data: enrollment,
  });
}

export async function getCourseMembersService(req: Request, res: Response, _next: NextFunction) {
  const { courseId } = req.params;

  const course = await Course.findById(courseId);
  if (!course) {
    return res.status(404).json({
      error: {
        code: 'NOT_FOUND',
        message: 'Course not found',
        details: [{ field: 'courseId', message: 'Course not found' }],
      },
    });
  }

  const members = await Enrollment.find({ courseId: course._id, status: 'active' })
    .populate('studentId', 'email firstNames lastName')
    .lean();

  return res.status(200).json({
    data: members.map((m) => ({
      id: m.studentId._id,
      email: m.studentId.email,
      firstNames: m.studentId.firstNames,
      lastNames: m.studentId.lastName,
      joinedAt: m.joinedAt,
    })),
  });
}

export async function removeMemberService(req: Request, res: Response, _next: NextFunction) {
  const { courseId, studentId } = req.params;

  const course = await Course.findById(courseId);
  if (!course) {
    return res.status(404).json({
      error: {
        code: 'NOT_FOUND',
        message: 'Course not found',
        details: [{ field: 'courseId', message: 'Course not found' }],
      },
    });
  }

  // Remove enrollment (soft delete by setting status to removed)
  const enrollment = await Enrollment.findOneAndUpdate(
    { courseId, studentId },
    { status: 'removed' },
    { new: true }
  );

  if (!enrollment) {
    return res.status(404).json({
      error: {
        code: 'NOT_FOUND',
        message: 'Enrollment not found',
        details: [{ field: 'studentId', message: 'Enrollment not found' }],
      },
    });
  }

  return res.status(204).end();
}