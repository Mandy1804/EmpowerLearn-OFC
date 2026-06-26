import express from "express";
import { ProgressoMateriaController } from "../controllers/progresso_materia.controller";
import asyncHandler from "express-async-handler";
import { permitir } from "../middlewares/permissao.middleware";

export const progressoRoutes = express.Router();

progressoRoutes.get(
  "/progresso-materias",
  permitir("aluno", "professor", "admin"),
  asyncHandler(ProgressoMateriaController.getAll),
);

progressoRoutes.get(
  "/progresso-materias/:id",
  permitir("aluno", "professor", "admin"),
  asyncHandler(ProgressoMateriaController.getById),
);

progressoRoutes.post(
  "/progresso-materias",
  permitir("aluno", "admin"),
  asyncHandler(ProgressoMateriaController.save),
);

progressoRoutes.delete(
  "/progresso-materias/:id",
  permitir("admin"),
  asyncHandler(ProgressoMateriaController.delete),
);
