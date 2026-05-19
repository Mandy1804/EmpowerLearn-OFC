import express from "express";
import { InstituicaoController } from "../controller/instituicao.controller";

export const instituicaoRoutes = express.Router();

instituicaoRoutes.get("/instituicoes", InstituicaoController.getAll);
instituicaoRoutes.get("/instituicoes/:id", InstituicaoController.getById);
instituicaoRoutes.post("/instituicoes", InstituicaoController.save);
instituicaoRoutes.put("/instituicoes/:id", InstituicaoController.update);
instituicaoRoutes.delete("/instituicoes/:id", InstituicaoController.delete);