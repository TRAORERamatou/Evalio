import mongoose, { Schema, Document, Model } from 'mongoose';

export interface ICourse extends Document {
  title: string;
  code: string;
  description?: string;
  teacherId: mongoose.Types.ObjectId;
  classGroupId?: mongoose.Types.ObjectId;
  joinCode: string;
  isArchived: boolean;
}

const courseSchema = new Schema(
  {
    title: { type: String, required: true, trim: true },
    code: { type: String, required: true, unique: true },
    description: { type: String },
    teacherId: { type: Schema.Types.ObjectId, required: true },
    classGroupId: { type: Schema.Types.ObjectId, default: null },
    joinCode: { type: String, required: true, unique: true, enumLength: 8 },
    isArchived: { type: Boolean, default: false },
  },
  { timestamps: true }
);

// Define indexes after schema creation
courseSchema.index({ code: 1 }, { unique: true });
courseSchema.index({ teacherId: 1 });
courseSchema.index({ joinCode: 1 }, { unique: true });

export const Course: Model<ICourse> = mongoose.model('Course', courseSchema);

export interface IEnrollment extends Document {
  courseId: mongoose.Types.ObjectId;
  studentId: mongoose.Types.ObjectId;
  status: 'active' | 'removed';
  joinedAt: Date;
}

const enrollmentSchema = new Schema(
  {
    courseId: { type: Schema.Types.ObjectId, required: true, ref: 'Course' },
    studentId: { type: Schema.Types.ObjectId, required: true, ref: 'User' },
    status: { type: String, enum: ['active', 'removed'], default: 'active' },
    joinedAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

// Define indexes after schema creation
enrollmentSchema.index({ courseId: 1, studentId: 1 }, { unique: true });
enrollmentSchema.index({ studentId: 1, status: 1 });

export const Enrollment: Model<IEnrollment> = mongoose.model('Enrollment', enrollmentSchema);