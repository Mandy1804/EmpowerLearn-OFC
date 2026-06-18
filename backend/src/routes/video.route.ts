import express from 'express';
import { VideoController } from '../controllers/video.controller';
import asyncHandler from 'express-async-handler';

export const videoRoutes = express.Router();

videoRoutes.get('/videos', asyncHandler(VideoController.getAll));
videoRoutes.get('/videos/:id', asyncHandler(VideoController.getById));
videoRoutes.post('/videos', asyncHandler(VideoController.save));
videoRoutes.put('/videos/:id', asyncHandler(VideoController.update));
videoRoutes.delete('/videos/:id', asyncHandler(VideoController.delete));