import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class AssinaturaRepository {
    async getAll() { return await prisma.assinatura.findMany(); }
    async getById(id: number) {
        const item = await prisma.assinatura.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Assinatura não encontrada");
        return item;
    }
    async save(data: any) { return await prisma.assinatura.create({ data }); }
    async update(id: number, data: any) { return await prisma.assinatura.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.assinatura.delete({ where: { id } }); }
}