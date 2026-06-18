import express from 'express';
import { ProgressoMateriaController } from '../controllers/progresso_materia.controller';
import asyncHandler from 'express-async-handler';

export const progressoRoutes = express.Router();

progressoRoutes.get('/progressos', asyncHandler(ProgressoMateriaController.getAll));
progressoRoutes.get('/progressos/:id', asyncHandler(ProgressoMateriaController.getById));
progressoRoutes.post('/progressos', asyncHandler(ProgressoMateriaController.save));
progressoRoutes.delete('/progressos/:id', asyncHandler(ProgressoMateriaController.delete));