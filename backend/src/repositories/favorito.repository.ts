import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class FavoritoRepository {
    async getAll() { return await prisma.favorito.findMany(); }
    async getById(id: number) {
        const item = await prisma.favorito.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Favorito não encontrado");
        return item;
    }
    async save(data: any) { return await prisma.favorito.create({ data }); }
    async update(id: number, data: any) { return await prisma.favorito.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.favorito.delete({ where: { id } }); }
}