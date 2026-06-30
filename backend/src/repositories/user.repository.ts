import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

const perfilSelect = {
    id: true,
    nome: true,
    email: true,
    tipo: true,
    ativo: true,
    fotoUrl: true,
    instituicaoId: true,
    createdAt: true,
    updatedAt: true,
};

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

    async getPerfilById(id: number) {
        const user = await prisma.usuario.findUnique({
            where: { id },
            select: perfilSelect
        });

        if (!user) throw new NotFoundError("Usuário não encontrado");

        return user;
    }

    async findByEmail(email: string) {
        return await prisma.usuario.findUnique({
            where: { email }
        });
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

    async updatePerfil(id: number, data: any) {
        return await prisma.usuario.update({
            where: { id },
            data,
            select: perfilSelect
        });
    }

    async delete(id: number) {
        return await prisma.usuario.delete({
            where: { id }
        });
    }
}
