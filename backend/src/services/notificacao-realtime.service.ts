import { io } from '../index';
import prisma from '../config/prisma';

export class NotificacaoRealtimeService {

    async enviar(usuarioId: number, titulo: string, mensagem: string, tipo: string) {
        await prisma.notificacao.create({
            data: {
                usuarioId,
                titulo,
                mensagem,
                tipo,
                lida: false
            }
        });

        io.to(`usuario_${usuarioId}`).emit('notificacao', {
            titulo,
            mensagem,
            tipo,
            criadoEm: new Date()
        });
    }
}