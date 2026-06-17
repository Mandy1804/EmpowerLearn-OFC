import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class CategoriaRepository {
    async getAll() { return await prisma.categoria.findMany(); }
    async getById(id: number) {
        const item = await prisma.categoria.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Categoria não encontrada");
        return item;
    }
    async save(data: any) { return await prisma.categoria.create({ data }); }
    async update(id: number, data: any) { return await prisma.categoria.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.categoria.delete({ where: { id } }); }
}