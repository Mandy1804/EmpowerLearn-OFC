import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class ComentarioRepository {
    async getAll() { return await prisma.comentario.findMany(); }
    async getById(id: number) {
        const item = await prisma.comentario.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Comentário não encontrado");
        return item;
    }
    async save(data: any) { return await prisma.comentario.create({ data }); }
    async update(id: number, data: any) { return await prisma.comentario.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.comentario.delete({ where: { id } }); }
}