import prisma from "../config/prisma";
import { NotFoundError } from "../errors/not-found.error";

export class ForumRepository {
  private formatarPost(post: any, autor?: any) {
    const autorReal = autor ?? post.autor;

    return {
      id: post.id,
      cursoId: post.cursoId,
      autorId: post.autorId,
      titulo: post.titulo,
      conteudo: post.conteudo,
      createdAt: post.createdAt,
      autorNome: autorReal?.nome ?? "Usuário",
      autorEmail: autorReal?.email ?? "",
      autorFoto: autorReal?.fotoUrl ?? null,
      autorTipo: autorReal?.tipo ?? "",
      cursoTitulo: post.curso?.titulo ?? post.curso?.nome ?? "",
      comentarios: post.comentarios ?? [],
    };
  }

  private async buscarAutoresPorIds(ids: number[]) {
    const idsValidos = [...new Set(ids.filter((id) => id > 0))];

    if (idsValidos.length === 0) {
      return new Map<number, any>();
    }

    const autores = await prisma.usuario.findMany({
      where: {
        id: {
          in: idsValidos,
        },
      },
      select: {
        id: true,
        nome: true,
        email: true,
        fotoUrl: true,
        tipo: true,
      },
    });

    return new Map(autores.map((autor) => [autor.id, autor]));
  }

  async getAll() {
    const posts = await prisma.postForum.findMany({
      include: {
        curso: true,
        comentarios: true,
      },
      orderBy: {
        createdAt: "desc",
      },
    });

    const autoresPorId = await this.buscarAutoresPorIds(
      posts.map((post) => Number(post.autorId)),
    );

    return posts.map((post) =>
      this.formatarPost(post, autoresPorId.get(Number(post.autorId))),
    );
  }

  async getById(id: number) {
    const item = await prisma.postForum.findUnique({
      where: { id },
      include: {
        curso: true,
        comentarios: true,
      },
    });

    if (!item) throw new NotFoundError("Post do fórum não encontrado");

    const autoresPorId = await this.buscarAutoresPorIds([Number(item.autorId)]);

    return this.formatarPost(item, autoresPorId.get(Number(item.autorId)));
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
        curso: true,
        comentarios: true,
      },
    });

    const autoresPorId = await this.buscarAutoresPorIds([autorId]);

    return this.formatarPost(postCriado, autoresPorId.get(autorId));
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
        curso: true,
        comentarios: true,
      },
    });

    const autoresPorId = await this.buscarAutoresPorIds([
      Number(postAtualizado.autorId),
    ]);

    return this.formatarPost(
      postAtualizado,
      autoresPorId.get(Number(postAtualizado.autorId)),
    );
  }

  async delete(id: number) {
    return await prisma.postForum.delete({ where: { id } });
  }
}
