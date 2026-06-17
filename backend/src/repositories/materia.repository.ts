import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class MateriaRepository {
    async getAll() { return await prisma.materia.findMany(); }
    async getById(id: number) {
        const item = await prisma.materia.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Matéria não encontrada");
        return item;
    }
    async save(data: any) { return await prisma.materia.create({ data }); }
    async update(id: number, data: any) { return await prisma.materia.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.materia.delete({ where: { id } }); }
}