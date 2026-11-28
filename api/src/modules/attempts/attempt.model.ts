import { model, Schema, Types } from 'mongoose';

export interface IAttempt {
  _id: Types.ObjectId;
  quizId: Types.ObjectId; // Reference to Quiz
  courseId: Types.ObjectId; // Reference to Course
  studentId: Types.ObjectId; // Reference to User (enrolled student)
  status: 'in_progress' | 'pending_grading' | 'graded';
  startedAt?: Date;
  deadline?: Date;
  endedAt?: Date;
  endReason?: 'submitted' | 'timeout' | 'ejected';
  questionOrder?: Types.ObjectId[]; // Ordered list of question references
  answers: IAttemptAnswer[];
  exits: IAttemptExit[];
  exitCount: number;
  lastHeartbeatAt?: Date;
  rejectedSaves: IAttemptRejectedSave[];
  score: number; // Score in hundredths (e.g. 1550 = 15.50)
  maxScore: number; // Max score in hundredths
  createdAt: Date;
  updatedAt: Date;
}

export interface IAttemptAnswer {
  questionId: Types.ObjectId;
  selectedOptionIds?: Types.ObjectId[];
  text?: string; // For written answers
  savedAt: Date;
  clientSeq?: number;
  awarded?: boolean;
  comment?: string;
}

export interface IAttemptExit {
  clientEventId: Types.ObjectId;
  leftAt: Date;
  durationMs: number;
  receivedAt: Date;
}

export interface IAttemptRejectedSave {
  clientSeq: number;
  rejectedAt: Date;
}

const AttemptSchema = new Schema<IAttempt>(
  {
    quizId: {
      type: Types.ObjectId,
      ref: 'Quiz',
      required: true,
    },
    courseId: {
      type: Types.ObjectId,
      ref: 'Course',
      required: true,
    },
    studentId: {
      type: Types.ObjectId,
      ref: 'User',
      required: true,
    },
    status: {
      type: String,
      enum: ['in_progress', 'pending_grading', 'graded'],
      required: true,
      default: 'in_progress',
    },
    startedAt: { type: Date },
    deadline: { type: Date },
    endedAt: { type: Date },
    endReason: { type: String, enum: ['submitted', 'timeout', 'ejected'] },
    questionOrder: [{ type: Types.ObjectId }],
    answers: {
      type: [
        {
          questionId: { type: Types.ObjectId, required: true },
          selectedOptionIds: [{ type: Types.ObjectId }],
          text: { type: String },
          savedAt: { type: Date, default: Date.now },
          clientSeq: { type: Number },
          awarded: { type: Boolean, default: false },
          comment: { type: String },
        },
      ],
    },
    exits: {
      type: [
        {
          clientEventId: { type: Types.ObjectId, required: true },
          leftAt: { type: Date, required: true },
          durationMs: { type: Number, required: true },
          receivedAt: { type: Date, default: Date.now },
        },
      ],
    },
    exitCount: {
      type: Number,
      min: 0,
      default: 0,
    },
    lastHeartbeatAt: { type: Date },
    rejectedSaves: {
      type: [
        {
          clientSeq: { type: Number, required: true },
          rejectedAt: { type: Date, default: Date.now },
        },
      ],
    },
    score: {
      type: Number,
      min: 0,
      default: 0,
    },
    maxScore: {
      type: Number,
      min: 0,
      default: 0,
    },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

// Indexes
AttemptSchema.index({ quizId: 1, studentId: 1, number: 1 }, { unique: true });
AttemptSchema.index({ quizId: 1, studentId: 1, status: 1 });
AttemptSchema.index({ quizId: 1, studentId: 1 }, { partialFilterExpression: { status: 'in_progress' } });
AttemptSchema.index({ status: 1, deadline: 1 });
AttemptSchema.index({ quizId: 1, score: -1 });

export const Attempt = model<IAttempt>('Attempt', AttemptSchema);