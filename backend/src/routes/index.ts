import express from "express";
import { userRoutes } from "./users.route";
import { professorRoutes } from "./professor.route";
import { instituicaoRoutes } from "./instituicao.route";
import { cursoRoutes } from "./curso.route";
import { materiaRoutes } from "./materia.route";
import { matriculaRoutes } from "./matricula.route";
import { progressoRoutes } from "./progresso_materia.route";
import { tarefaRoutes } from "./tarefa.route";
import { submissaoRoutes } from "./submissao.route";
import { postForumRoutes } from "./post_forum.route";
import { comentarioRoutes } from "./comentario.route";
import { planoRoutes } from "./plano.route";
import { assinaturaRoutes } from "./assinatura.route";
import { notificacaoRoutes } from "./notificacao.route";
import { mensagemRoutes } from "./mensagem_chat.route";
import { categoriaRoutes } from "./categoria.route";
import { videoRoutes } from "./video.route";
import { historicoRoutes } from "./historico.route";
import { favoritoRoutes } from "./favorito.route";
import { notaRoutes } from "./nota_aluno.route";
import { refreshTokenRoutes } from "./refresh_token.route";

const allRoutes = [
    userRoutes, professorRoutes, instituicaoRoutes,
    cursoRoutes, materiaRoutes, matriculaRoutes,
    progressoRoutes, tarefaRoutes, submissaoRoutes,
    postForumRoutes, comentarioRoutes, planoRoutes,
    assinaturaRoutes, notificacaoRoutes, mensagemRoutes,
    categoriaRoutes, videoRoutes, historicoRoutes,
    favoritoRoutes, notaRoutes, refreshTokenRoutes
];

export const routes = (app: express.Express) => {
    app.use(express.json());
    allRoutes.forEach(route => app.use(route));
};