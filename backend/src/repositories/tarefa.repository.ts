import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class TarefaRepository {
    async getAll() { return await prisma.tarefa.findMany(); }
    async getById(id: number) {
        const item = await prisma.tarefa.findUnique({ where: { id } });
        if (!item) throw new NotFoundError("Tarefa não encontrada");
        return item;
    }
    async save(data: any) { return await prisma.tarefa.create({ data }); }
    async update(id: number, data: any) { return await prisma.tarefa.update({ where: { id }, data }); }
    async delete(id: number) { return await prisma.tarefa.delete({ where: { id } }); }
}