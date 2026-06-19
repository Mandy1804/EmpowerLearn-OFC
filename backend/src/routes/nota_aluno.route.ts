import express from 'express';
import { NotaAlunoController } from '../controllers/nota_aluno.controller';
import asyncHandler from 'express-async-handler';

export const notaRoutes = express.Router();

notaRoutes.get('/notas', asyncHandler(NotaAlunoController.getAll));
notaRoutes.get('/notas/:id', asyncHandler(NotaAlunoController.getById));
notaRoutes.post('/notas', asyncHandler(NotaAlunoController.save));
notaRoutes.put('/notas/:id', asyncHandler(NotaAlunoController.update));
notaRoutes.delete('/notas/:id', asyncHandler(NotaAlunoController.delete));