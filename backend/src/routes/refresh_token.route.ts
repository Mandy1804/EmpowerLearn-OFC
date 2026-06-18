import express from 'express';
import { RefreshTokenController } from '../controllers/refresh_token.controller';
import asyncHandler from 'express-async-handler';

export const refreshTokenRoutes = express.Router();

refreshTokenRoutes.get('/tokens/:id', asyncHandler(RefreshTokenController.getById));
refreshTokenRoutes.delete('/tokens/:id', asyncHandler(RefreshTokenController.delete));