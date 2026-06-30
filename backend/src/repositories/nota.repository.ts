import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class NotaRepository {
    async getAll() { return await prisma.notaAluno.findMany(); }
    async getById(id: number) {
        const item = await prisma.notaAluno.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Nota não encontrada");
        return item;
    }
    async save(data: any) { return await prisma.notaAluno.create({ data }); }
    async update(id: number, data: any) { return await prisma.notaAluno.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.notaAluno.delete({ where: { id } }); }
}