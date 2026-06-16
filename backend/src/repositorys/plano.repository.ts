import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class PlanoRepository {
    async getAll() { return await prisma.plano.findMany(); }
    async getById(id: number) {
        const item = await prisma.plano.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Plano não encontrado");
        return item;
    }
    async save(data: any) { return await prisma.plano.create({ data }); }
    async update(id: number, data: any) { return await prisma.plano.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.plano.delete({ where: { id } }); }
}