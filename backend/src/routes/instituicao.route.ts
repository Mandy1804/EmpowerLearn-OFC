import express from "express";
import { InstituicaoController } from "../controller/instituicao.controller";
import asyncHandler from "express-async-handler";
import { celebrate, Segments } from "celebrate";
import { instituicaoSchema } from "../models/instituicao.model";

export const instituicaoRoutes = express.Router();

instituicaoRoutes.get("/instituicoes", asyncHandler(InstituicaoController.getAll));
instituicaoRoutes.get("/instituicoes/:id", asyncHandler(InstituicaoController.getById));
instituicaoRoutes.post("/instituicoes", celebrate ({[Segments.BODY]: instituicaoSchema}), asyncHandler(InstituicaoController.save));
instituicaoRoutes.put("/instituicoes/:id", celebrate ({[Segments.BODY]: instituicaoSchema}), asyncHandler(InstituicaoController.update));
instituicaoRoutes.delete("/instituicoes/:id", asyncHandler(InstituicaoController.delete));