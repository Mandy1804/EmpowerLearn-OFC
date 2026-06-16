import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class MatriculaRepository {
    async getAll() { return await prisma.matricula.findMany(); }
    async getById(id: number) {
        const item = await prisma.matricula.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Matrícula não encontrada");
        return item;
    }
    async save(data: any) { return await prisma.matricula.create({ data }); }
    async delete(id: number) { return await prisma.matricula.delete({ where: { id } }); }
}