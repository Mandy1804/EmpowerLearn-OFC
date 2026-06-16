import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class ProfessorRepository {

    async getAll() {
        return await prisma.usuario.findMany({
            where: { tipo: "professor" }
        });
    }

    async getById(id: number) {
        const professor = await prisma.usuario.findUnique({ 
            where: { id } 
        });
        if (!professor) throw new NotFoundError("Professor não encontrado");
        return professor;
    }

    async save(data: any) {
        return await prisma.usuario.create({ data });
    }

    async update(id: number, data: any) {
        return await prisma.usuario.update({ 
            where: { id }, 
            data 
        });
    }

    async delete(id: number) {
        return await prisma.usuario.delete({ 
            where: { id } 
        });
    }
}