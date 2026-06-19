import express from 'express';
import { SubmissaoController } from '../controllers/submissao.controller';
import asyncHandler from 'express-async-handler';

export const submissaoRoutes = express.Router();

submissaoRoutes.get('/submissoes', asyncHandler(SubmissaoController.getAll));
submissaoRoutes.get('/submissoes/:id', asyncHandler(SubmissaoController.getById));
submissaoRoutes.post('/submissoes', asyncHandler(SubmissaoController.save));
submissaoRoutes.put('/submissoes/:id', asyncHandler(SubmissaoController.update));
submissaoRoutes.delete('/submissoes/:id', asyncHandler(SubmissaoController.delete));