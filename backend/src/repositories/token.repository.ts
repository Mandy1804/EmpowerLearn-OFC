import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class TokenRepository {
    async getById(id: number) {
        const item = await prisma.refreshToken.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Token não encontrado");
        return item;
    }
    async getByToken(token: string) {
        return await prisma.refreshToken.findUnique({ where: { token } });
    }
    async save(data: any) { return await prisma.refreshToken.create({ data }); }
    async delete(id: number) { return await prisma.refreshToken.delete({ where: { id } }); }
}