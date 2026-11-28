import { model, Schema, Types } from 'mongoose';

export interface IUser {
  _id: Types.ObjectId;
  firstName: string;
  lastName: string;
  email: string;
  passwordHash: string; // Argon2id hash, never returned in responses
  role: 'student' | 'teacher' | 'admin' | 'super_admin';
  studentId?: string; // e.g. school matricule
  schoolId?: Types.ObjectId; // Reference to School
  isActive: boolean;
  createdAt: Date;
  updatedAt: Date;
}

const UserSchema = new Schema<IUser>(
  {
    firstName: { type: String, required: true, trim: true },
    lastName: { type: String, required: true, trim: true },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },
    passwordHash: { type: String, required: true },
    role: {
      type: String,
      enum: ['student', 'teacher', 'admin', 'super_admin'],
      required: true,
    },
    studentId: { type: String, trim: true },
    schoolId: { type: Types.ObjectId, ref: 'School' },
    isActive: { type: Boolean, default: true },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

// Indexes
UserSchema.index({ email: 1 }, { unique: true });
UserSchema.index(
  { schoolId: 1, studentId: 1 },
  { unique: true, partialFilterExpression: { studentId: { $exists: true } } }
);

export const User = model<IUser>('User', UserSchema);