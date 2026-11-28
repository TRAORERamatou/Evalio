import { model, Schema, Types } from 'mongoose';

export interface IQuiz {
  _id: Types.ObjectId;
  courseId: Types.ObjectId; // Reference to Course
  authorId: Types.ObjectId; // Reference to User (owner)
  title: string;
  instructions?: string;
  status: 'draft' | 'published' | 'closed' | 'deliberated' | 'released';
  opensAt?: Date;
  closesAt?: Date;
  durationSec?: number;
  settings: {
    maxAttempts: number;
    focus: {
      mode: 'warning' | 'strict' | 'observe';
      maxExits: number;
      maxAbsenceSec: number;
    };
    release: 'immediate' | 'after_deliberation';
    showAnswers: 'after_close' | 'never';
    leaderboard: boolean;
    shuffleQuestions: boolean;
    shuffleOptions: boolean;
  };
  appealDeadline?: Date;
  appealAnswersAt?: Date;
  firstAttemptAt?: Date; // Freezes content after first attempt
  createdAt: Date;
  updatedAt: Date;
}

const QuizSchema = new Schema<IQuiz>(
  {
    courseId: {
      type: Types.ObjectId,
      ref: 'Course',
      required: true,
    },
    authorId: {
      type: Types.ObjectId,
      ref: 'User',
      required: true,
    },
    title: { type: String, required: true, trim: true },
    instructions: { type: String, trim: true },
    status: {
      type: String,
      enum: ['draft', 'published', 'closed', 'deliberated', 'released'],
      required: true,
      default: 'draft',
    },
    opensAt: { type: Date },
    closesAt: { type: Date },
    durationSec: { type: Number },
    settings: {
      maxAttempts: {
        type: Number,
        min: 1,
        default: 1,
      },
      focus: {
        mode: {
          type: String,
          enum: ['warning', 'strict', 'observe'],
          default: 'warning',
        },
        maxExits: {
          type: Number,
          default: 3,
        },
        maxAbsenceSec: {
          type: Number,
          default: 10,
        },
      },
      release: {
        type: String,
        enum: ['immediate', 'after_deliberation'],
        default: 'immediate',
      },
      showAnswers: {
        type: String,
        enum: ['after_close', 'never'],
        default: 'after_close',
      },
      leaderboard: {
        type: Boolean,
        default: false,
      },
      shuffleQuestions: {
        type: Boolean,
        default: false,
      },
      shuffleOptions: {
        type: Boolean,
        default: false,
      },
    },
    appealDeadline: { type: Date },
    appealAnswersAt: { type: Date },
    firstAttemptAt: { type: Date },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

// Indexes
QuizSchema.index({ courseId: 1, status: 1, opensAt: -1 });
QuizSchema.index({ status: 1, closesAt: 1 });
QuizSchema.index({ authorId: 1, createdAt: -1 });

export const Quiz = model<IQuiz>('Quiz', QuizSchema);