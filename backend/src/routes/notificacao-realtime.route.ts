import express from 'express';
import asyncHandler from 'express-async-handler';
import { NotificacaoRealtimeService } from '../services/notificacao-realtime.service';
import { parseId } from '../utils/parse-id';

export const notificacaoRealtimeRoutes = express.Router();

const service = new NotificacaoRealtimeService();

notificacaoRealtimeRoutes.post('/notificacoes/enviar', asyncHandler(async (req, res) => {
    const { usuarioId, titulo, mensagem, tipo } = req.body;
    await service.enviar(usuarioId, titulo, mensagem, tipo);
    res.status(201).send({ message: 'Notificação enviada com sucesso' });
}));