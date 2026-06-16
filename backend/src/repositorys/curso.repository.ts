import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class CursoRepository {
    async getAll() {
        return await prisma.curso.findMany();
    }
    async getById(id: number) {
        const curso = await prisma.curso.findUnique({ where: { id } });
        if (!curso) throw new NotFoundError("Curso não encontrado");
        return curso;
    }
    async save(data: any) {
        return await prisma.curso.create({ data });
    }
    async update(id: number, data: any) {
        return await prisma.curso.update({ where: { id }, data });
    }
    async delete(id: number) {
        return await prisma.curso.delete({ where: { id } });
    }
}