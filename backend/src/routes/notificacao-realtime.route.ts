import express from 'express';
import asyncHandler from 'express-async-handler';
import { NotificacaoRealtimeService } from '../services/notificacao-realtime.service';

export const notificacaoRealtimeRoutes = express.Router();

const service = new NotificacaoRealtimeService();

notificacaoRealtimeRoutes.post('/notificacoes/enviar', asyncHandler(async (req, res) => {
    const userTipo = (req as any).userTipo;

    if (userTipo !== 'admin') {
        res.status(403).send({
            message: 'Acesso negado. Apenas admin pode enviar notificações manualmente.',
        });
        return;
    }

    const { usuarioId, titulo, mensagem, tipo } = req.body;

    const usuarioIdNumber = Number(usuarioId);

    if (!Number.isInteger(usuarioIdNumber) || usuarioIdNumber <= 0) {
        res.status(400).send({
            message: 'usuarioId inválido',
        });
        return;
    }

    if (!titulo || typeof titulo !== 'string') {
        res.status(400).send({
            message: 'Título da notificação é obrigatório',
        });
        return;
    }

    if (!mensagem || typeof mensagem !== 'string') {
        res.status(400).send({
            message: 'Mensagem da notificação é obrigatória',
        });
        return;
    }

    const tipoFinal = typeof tipo === 'string' && tipo.trim() ? tipo.trim() : 'sistema';

    await service.enviar(
        usuarioIdNumber,
        titulo.trim(),
        mensagem.trim(),
        tipoFinal
    );

    res.status(201).send({
        message: 'Notificação enviada com sucesso',
    });
}));
