import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class HistoricoRepository {
    async getAll() { return await prisma.historico.findMany(); }
    async getById(id: number) {
        const item = await prisma.historico.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Histórico não encontrado");
        return item;
    }
    async save(data: any) { return await prisma.historico.create({ data }); }
    async delete(id: number) { return await prisma.historico.delete({ where: { id } }); }
}