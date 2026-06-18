import express from 'express';
import { NotificacaoController } from '../controllers/notificacao.controller';
import asyncHandler from 'express-async-handler';

export const notificacaoRoutes = express.Router();

notificacaoRoutes.get('/notificacoes', asyncHandler(NotificacaoController.getAll));
notificacaoRoutes.get('/notificacoes/:id', asyncHandler(NotificacaoController.getById));
notificacaoRoutes.post('/notificacoes', asyncHandler(NotificacaoController.save));
notificacaoRoutes.put('/notificacoes/:id', asyncHandler(NotificacaoController.update));
notificacaoRoutes.delete('/notificacoes/:id', asyncHandler(NotificacaoController.delete));