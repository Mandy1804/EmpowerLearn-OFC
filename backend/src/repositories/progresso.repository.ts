import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class ProgressoRepository {
    async getAll() { return await prisma.progressoMateria.findMany(); }
    async getById(id: number) {
        const item = await prisma.progressoMateria.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Progresso não encontrado");
        return item;
    }
    async save(data: any) { return await prisma.progressoMateria.create({ data }); }
    async delete(id: number) { return await prisma.progressoMateria.delete({ where: { id } }); }
}