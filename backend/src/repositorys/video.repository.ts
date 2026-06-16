import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class VideoRepository {
    async getAll() { return await prisma.video.findMany(); }
    async getById(id: number) {
        const item = await prisma.video.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Vídeo não encontrado");
        return item;
    }
    async save(data: any) { return await prisma.video.create({ data }); }
    async update(id: number, data: any) { return await prisma.video.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.video.delete({ where: { id } }); }
}