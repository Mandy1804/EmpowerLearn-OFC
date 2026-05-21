import express from "express";
import { InstituicaoController } from "../controller/instituicao.controller";
import asyncHandler from "express-async-handler";

export const instituicaoRoutes = express.Router();

instituicaoRoutes.get("/instituicoes", asyncHandler(InstituicaoController.getAll));
instituicaoRoutes.get("/instituicoes/:id", asyncHandler(InstituicaoController.getById));
instituicaoRoutes.post("/instituicoes", asyncHandler(InstituicaoController.save));
instituicaoRoutes.put("/instituicoes/:id", asyncHandler(InstituicaoController.update));
instituicaoRoutes.delete("/instituicoes/:id", asyncHandler(InstituicaoController.delete));