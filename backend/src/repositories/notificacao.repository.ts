import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class NotificacaoRepository {
    async getAll() { return await prisma.notificacao.findMany(); }
    async getById(id: number) {
        const item = await prisma.notificacao.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Notificação não encontrada");
        return item;
    }
    async save(data: any) { return await prisma.notificacao.create({ data }); }
    async update(id: number, data: any) { return await prisma.notificacao.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.notificacao.delete({ where: { id } }); }
}