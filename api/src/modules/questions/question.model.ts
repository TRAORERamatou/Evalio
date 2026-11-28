import { model, Schema, Types } from 'mongoose';

export interface IQuestion {
  _id: Types.ObjectId;
  quizId: Types.ObjectId; // Reference to Quiz
  position: number; // Order within the quiz
  type: 'single' | 'multiple' | 'written'; // Question type
  text: string; // Question text (required)
  points: number; // Points in hundredths (e.g. 200 = 2.00)
  options?: IQuestionOption[]; // Embedded options (for single/multiple choice)
  correctOptionIds: Types.ObjectId[]; // IDs of correct options (select:false)
  gradingNotes?: string; // Instructor-only notes (select:false)
  timeLimitSec?: number; // Time limit for answering (optional)
  createdAt: Date;
  updatedAt: Date;
}

export interface IQuestionOption {
  id: Types.ObjectId; // Option ID
  text: string; // Option text (required)
  isCorrect?: boolean; // Whether this is the correct answer (optional for written)
  select?: boolean; // If false, option is hidden from students (default: true)
}

const QuestionSchema = new Schema<IQuestion>(
  {
    quizId: {
      type: Types.ObjectId,
      ref: 'Quiz',
      required: true,
    },
    position: {
      type: Number,
      required: true,
      min: 1,
    },
    type: {
      type: String,
      enum: ['single', 'multiple', 'written'],
      required: true,
    },
    text: {
      type: String,
      required: true,
      trim: true,
    },
    points: {
      type: Number,
      min: 1,
      required: true,
    },
    options: {
      type: [
        {
          id: { type: Types.ObjectId, required: true },
          text: { type: String, required: true },
          isCorrect: { type: Boolean, default: false },
          select: { type: Boolean, default: true },
        },
      ],
      validate: {
        max: 10, // Max 10 options per question
      },
    },
    correctOptionIds: {
      type: [Types.ObjectId],
    },
    gradingNotes: { type: String, select: false }, // Instructor-only, hidden from students
    timeLimitSec: { type: Number, min: 1 },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

// Indexes
QuestionSchema.index({ quizId: 1, position: 1 }, { unique: true });
QuestionSchema.index({ quizId: 1, type: 1 });
QuestionSchema.index({ type: 1 });

export const Question = model<IQuestion>('Question', QuestionSchema);