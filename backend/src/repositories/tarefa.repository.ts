import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class TarefaRepository {
  private includePadrao = {
    materia: {
      include: {
        curso: true,
      },
    },
    submissoes: true,
  };

  async getAll(materiaId?: number) {
    return await prisma.tarefa.findMany({
      where: materiaId ? { materiaId } : undefined,
      include: this.includePadrao,
      orderBy: {
        createdAt: "desc",
      },
    });
  }

  async getById(id: number) {
    const item = await prisma.tarefa.findUnique({
      where: { id },
      include: this.includePadrao,
    });

    if (!item) {
      throw new NotFoundError("Tarefa não encontrada");
    }

    return item;
  }

  async save(data: any) {
    return await prisma.tarefa.create({
      data: {
        titulo: data.titulo,
        descricao: data.descricao ?? "",
        materiaId: Number(data.materiaId),
        prazo: new Date(data.prazo),
      },
      include: this.includePadrao,
    });
  }

  async update(id: number, data: any) {
    const dadosAtualizados: any = {};

    if (data.titulo !== undefined) {
      dadosAtualizados.titulo = data.titulo;
    }

    if (data.descricao !== undefined) {
      dadosAtualizados.descricao = data.descricao;
    }

    if (data.materiaId !== undefined) {
      dadosAtualizados.materiaId = Number(data.materiaId);
    }

    if (data.prazo !== undefined) {
      dadosAtualizados.prazo = new Date(data.prazo);
    }

    return await prisma.tarefa.update({
      where: { id },
      data: dadosAtualizados,
      include: this.includePadrao,
    });
  }

  async delete(id: number) {
    return await prisma.tarefa.delete({
      where: { id },
    });
  }
}