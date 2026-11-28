import { model, Schema, Types } from 'mongoose';

export interface ICourse {
  _id: Types.ObjectId;
  title: string;
  code?: string;
  description?: string;
  teacherId: Types.ObjectId; // Reference to User (role: teacher or admin)
  classGroupId?: Types.ObjectId; // Reference to ClassGroup (optional)
  joinCode: string; // Random 8-character code for enrollment
  isArchived: boolean; // Soft delete / archival
  createdAt: Date;
  updatedAt: Date;
}

const CourseSchema = new Schema<ICourse>(
  {
    title: { type: String, required: true, trim: true },
    code: { type: String, trim: true, sparse: true }, // Optional course code
    description: { type: String, trim: true },
    teacherId: {
      type: Types.ObjectId,
      ref: 'User',
      required: true,
    },
    classGroupId: { type: Types.ObjectId, ref: 'ClassGroup' },
    joinCode: {
      type: String,
      required: true,
      trim: true,
      uppercase: true,
    },
    isArchived: {
      type: Boolean,
      default: false,
    },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

// Indexes
CourseSchema.index({ joinCode: 1 }, { unique: true });
CourseSchema.index({ teacherId: 1, createdAt: -1 });
CourseSchema.index({ title: 'text', code: 'text' }); // Text search on title and code

export const Course = model<ICourse>('Course', CourseSchema);