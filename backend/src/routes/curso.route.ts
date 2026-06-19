import express from 'express';
import { CursoController } from '../controllers/curso.controller';
import asyncHandler from 'express-async-handler';

export const cursoRoutes = express.Router();

cursoRoutes.get('/cursos', asyncHandler(CursoController.getAll));
cursoRoutes.get('/cursos/:id', asyncHandler(CursoController.getById));
cursoRoutes.post('/cursos', asyncHandler(CursoController.save));
cursoRoutes.put('/cursos/:id', asyncHandler(CursoController.update));
cursoRoutes.delete('/cursos/:id', asyncHandler(CursoController.delete));