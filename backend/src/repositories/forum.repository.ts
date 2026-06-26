import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class ForumRepository {
  private formatarPost(post: any) {
    return {
      id: post.id,
      cursoId: post.cursoId,
      autorId: post.autorId,
      titulo: post.titulo,
      conteudo: post.conteudo,
      createdAt: post.createdAt,
      autorNome: post.autor?.nome ?? "Usuário",
      autorEmail: post.autor?.email ?? "",
      autorFoto: post.autor?.fotoUrl ?? null,
      autorTipo: post.autor?.tipo ?? "",
      cursoTitulo: post.curso?.titulo ?? post.curso?.nome ?? "",
      comentarios: post.comentarios ?? [],
    };
  }

  async getAll() {
    const posts = await prisma.postForum.findMany({
      include: {
        autor: {
          select: {
            id: true,
            nome: true,
            email: true,
            fotoUrl: true,
            tipo: true,
          },
        },
        curso: true,
        comentarios: true,
      },
      orderBy: {
        createdAt: "desc",
      },
    });

    return posts.map((post) => this.formatarPost(post));
  }

  async getById(id: number) {
    const item = await prisma.postForum.findUnique({
      where: { id },
      include: {
        autor: {
          select: {
            id: true,
            nome: true,
            email: true,
            fotoUrl: true,
            tipo: true,
          },
        },
        curso: true,
        comentarios: true,
      },
    });

    if (!item) throw new NotFoundError("Post do fórum não encontrado");

    return this.formatarPost(item);
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

    const titulo = conteudo.length > 50 ? conteudo.substring(0, 50) : conteudo;

    const postCriado = await prisma.postForum.create({
      data: {
        titulo,
        conteudo,
        autorId,
        cursoId,
      },
      include: {
        autor: {
          select: {
            id: true,
            nome: true,
            email: true,
            fotoUrl: true,
            tipo: true,
          },
        },
        curso: true,
        comentarios: true,
      },
    });

    return this.formatarPost(postCriado);
  }

  async update(id: number, data: any) {
    const payload: any = {};

    if (data?.titulo !== undefined) payload.titulo = String(data.titulo);
    if (data?.conteudo !== undefined) payload.conteudo = String(data.conteudo);
    if (data?.cursoId !== undefined) payload.cursoId = Number(data.cursoId);

    const postAtualizado = await prisma.postForum.update({
      where: { id },
      data: payload,
      include: {
        autor: {
          select: {
            id: true,
            nome: true,
            email: true,
            fotoUrl: true,
            tipo: true,
          },
        },
        curso: true,
        comentarios: true,
      },
    });

    return this.formatarPost(postAtualizado);
  }

  async delete(id: number) {
    return await prisma.postForum.delete({ where: { id } });
  }
}
