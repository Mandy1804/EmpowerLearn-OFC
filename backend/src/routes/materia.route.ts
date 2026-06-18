import express from 'express';
import { MateriaController } from '../controllers/materia.controller';
import asyncHandler from 'express-async-handler';

export const materiaRoutes = express.Router();

materiaRoutes.get('/materias', asyncHandler(MateriaController.getAll));
materiaRoutes.get('/materias/:id', asyncHandler(MateriaController.getById));
materiaRoutes.post('/materias', asyncHandler(MateriaController.save));
materiaRoutes.put('/materias/:id', asyncHandler(MateriaController.update));
materiaRoutes.delete('/materias/:id', asyncHandler(MateriaController.delete));