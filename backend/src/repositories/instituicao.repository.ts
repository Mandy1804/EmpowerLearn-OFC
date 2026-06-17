import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class InstituicaoRepository {

    async getAll() {
        return await prisma.instituicao.findMany();
    }

    async getById(id: number) {
        const instituicao = await prisma.instituicao.findUnique({ 
            where: { id } 
        });
        if (!instituicao) throw new NotFoundError("Instituição não encontrada");
        return instituicao;
    }

    async save(data: any) {
        return await prisma.instituicao.create({ data });
    }

    async update(id: number, data: any) {
        return await prisma.instituicao.update({ 
            where: { id }, 
            data 
        });
    }

    async delete(id: number) {
        return await prisma.instituicao.delete({ 
            where: { id } 
        });
    }
}