import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class SubmissaoRepository {
    async getAll() { return await prisma.submissao.findMany(); }
    async getById(id: number) {
        const item = await prisma.submissao.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Submissão não encontrada");
        return item;
    }
    async save(data: any) { return await prisma.submissao.create({ data }); }
    async update(id: number, data: any) { return await prisma.submissao.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.submissao.delete({ where: { id } }); }
}