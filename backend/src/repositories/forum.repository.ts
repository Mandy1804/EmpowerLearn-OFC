import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class ForumRepository {
  async getAll() {
    return await prisma.postForum.findMany({
      include: {
        autor: true,
        curso: true,
        comentarios: true,
      },
      orderBy: {
        createdAt: "desc",
      },
    });
  }

  async getById(id: number) {
    const item = await prisma.postForum.findUnique({
      where: { id },
      include: {
        autor: true,
        curso: true,
        comentarios: true,
      },
    });

    if (!item) throw new NotFoundError("Post do fórum não encontrado");

    return item;
  }

  async save(data: any) {
    const conteudo = String(data?.conteudo ?? "").trim();

    if (!conteudo) {
      throw new Error("Conteúdo da discussão é obrigatório");
    }

    const autorId = Number(data?.autorId ?? data?.usuarioId);
    let cursoId = Number(data?.cursoId);

    if (!autorId) {
      throw new Error("autorId é obrigatório");
    }

    if (!cursoId) {
      const primeiroCurso = await prisma.curso.findFirst({
        select: { id: true },
        orderBy: { id: "asc" },
      });

      if (!primeiroCurso) {
        throw new NotFoundError(
          "Nenhum curso encontrado para vincular a discussão",
        );
      }

      cursoId = primeiroCurso.id;
    }

    const tituloInformado = String(data?.titulo ?? "").trim();
    const titulo =
      tituloInformado ||
      (conteudo.length > 50 ? conteudo.substring(0, 50) : conteudo);

    return await prisma.postForum.create({
      data: {
        titulo,
        conteudo,
        autorId,
        cursoId,
      },
      include: {
        autor: true,
        curso: true,
        comentarios: true,
      },
    });
  }

  async update(id: number, data: any) {
    const payload: any = {};

    if (data?.titulo !== undefined) payload.titulo = String(data.titulo);
    if (data?.conteudo !== undefined) payload.conteudo = String(data.conteudo);
    if (data?.cursoId !== undefined) payload.cursoId = Number(data.cursoId);

    return await prisma.postForum.update({
      where: { id },
      data: payload,
    });
  }

  async delete(id: number) {
    return await prisma.postForum.delete({ where: { id } });
  }
}
