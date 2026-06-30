import express from "express";
import { UsersController } from "../controllers/users.controller";
import asyncHandler from "express-async-handler";
import { celebrate, Segments } from "celebrate";
import { userProfileUpdateSchema, userSchema } from "../models/users.model";
import { permitir } from '../middlewares/permissao.middleware';
import { uploadPerfil } from "../config/upload";

export const userRoutes = express.Router();

userRoutes.get("/users/me", permitir('aluno', 'professor', 'admin'), asyncHandler(UsersController.getMe));
userRoutes.put(
    "/users/me",
    permitir('aluno', 'professor', 'admin'),
    celebrate({ [Segments.BODY]: userProfileUpdateSchema }),
    asyncHandler(UsersController.updateMe)
);
userRoutes.post(
    "/users/me/foto",
    permitir('aluno', 'professor', 'admin'),
    uploadPerfil.single('foto'),
    asyncHandler(UsersController.uploadFoto)
);

userRoutes.get("/users", permitir('aluno', 'admin'), asyncHandler(UsersController.getAll));
userRoutes.get("/users/:id", permitir('admin'), asyncHandler(UsersController.getById));
userRoutes.post("/users", permitir('admin'), celebrate({ [Segments.BODY]: userSchema }), asyncHandler(UsersController.save));
userRoutes.put("/users/:id", permitir('aluno', 'admin'), celebrate({ [Segments.BODY]: userSchema }), asyncHandler(UsersController.update));
userRoutes.delete("/users/:id", permitir('aluno', 'admin'), asyncHandler(UsersController.delete));
