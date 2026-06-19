import express from 'express';
import { MatriculaController } from '../controllers/matricula.controller';
import asyncHandler from 'express-async-handler';

export const matriculaRoutes = express.Router();

matriculaRoutes.get('/matriculas', asyncHandler(MatriculaController.getAll));
matriculaRoutes.get('/matriculas/:id', asyncHandler(MatriculaController.getById));
matriculaRoutes.post('/matriculas', asyncHandler(MatriculaController.save));
matriculaRoutes.delete('/matriculas/:id', asyncHandler(MatriculaController.delete));