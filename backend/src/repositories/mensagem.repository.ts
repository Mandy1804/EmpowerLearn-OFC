import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class MensagemRepository {
    async getAll() { return await prisma.mensagemChat.findMany(); }
    async getById(id: number) {
        const item = await prisma.mensagemChat.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Mensagem não encontrada");
        return item;
    }
    async save(data: any) { return await prisma.mensagemChat.create({ data }); }
    async update(id: number, data: any) { return await prisma.mensagemChat.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.mensagemChat.delete({ where: { id } }); }
}