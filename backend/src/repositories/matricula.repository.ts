import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class MatriculaRepository {
  async getAll() {
    return await prisma.matricula.findMany({
      include: {
        aluno: true,
        curso: true,
      },
      orderBy: {
        dataMatricula: "desc",
      },
    });
  }

  async getById(id: number) {
    const item = await prisma.matricula.findUnique({
      where: { id },
      include: {
        aluno: true,
        curso: true,
      },
    });

    if (!item) throw new NotFoundError("Matrícula não encontrada");

    return item;
  }

  async save(data: any) {
    const alunoId = Number(data?.alunoId);
    const cursoId = Number(data?.cursoId);

    if (!alunoId || !cursoId) {
      throw new Error("alunoId e cursoId são obrigatórios");
    }

    const existente = await prisma.matricula.findUnique({
      where: {
        alunoId_cursoId: {
          alunoId,
          cursoId,
        },
      },
    });

    if (existente) {
      return existente;
    }

    return await prisma.matricula.create({
      data: {
        alunoId,
        cursoId,
      },
    });
  }

  async delete(id: number) {
    return await prisma.matricula.delete({ where: { id } });
  }
}
