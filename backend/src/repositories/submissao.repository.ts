import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class SubmissaoRepository {
  private includePadrao = {
    tarefa: {
      include: {
        materia: {
          include: {
            curso: true,
          },
        },
      },
    },
    aluno: {
      select: {
        id: true,
        nome: true,
        email: true,
      },
    },
  };

  async getAll(tarefaId?: number) {
    return await prisma.submissao.findMany({
      where: tarefaId ? { tarefaId } : undefined,
      include: this.includePadrao,
      orderBy: {
        entregueEm: "desc",
      },
    });
  }

  async getById(id: number) {
    const item = await prisma.submissao.findUnique({
      where: { id },
      include: this.includePadrao,
    });

    if (!item) {
      throw new NotFoundError("Submissão não encontrada");
    }

    return item;
  }

  async save(data: any) {
    const tarefaId = Number(data.tarefaId);
    const alunoId = Number(data.alunoId);
    const resposta = data.resposta?.toString().trim() ?? "";

    return await prisma.submissao.upsert({
      where: {
        tarefaId_alunoId: {
          tarefaId,
          alunoId,
        },
      },
      update: {
        resposta,
        entregueEm: new Date(),
      },
      create: {
        tarefaId,
        alunoId,
        resposta,
      },
      include: this.includePadrao,
    });
  }

  async update(id: number, data: any) {
    return await prisma.submissao.update({
      where: { id },
      data,
      include: this.includePadrao,
    });
  }

  async delete(id: number) {
    return await prisma.submissao.delete({
      where: { id },
    });
  }
}