import mongoose from 'mongoose';
import { createApp } from './app.js';
import { loadEnv } from './config/env.js';

const env = loadEnv();
await mongoose.connect(env.MONGODB_URI);
createApp().listen(env.PORT, () => console.log(`API listening on port ${env.PORT}`));
