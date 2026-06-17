import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class UserRepository {

    async getAll() {
        return await prisma.usuario.findMany();
    }

    async getById(id: number) {
        const user = await prisma.usuario.findUnique({ 
            where: { id } 
        });
        if (!user) throw new NotFoundError("Usuário não encontrado");
        return user;
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