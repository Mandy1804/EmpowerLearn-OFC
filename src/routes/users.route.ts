import express from "express";
import { UsersController } from "../controller/users.controller";

export const userRoutes = express.Router(); //um middleware para organizar as rotas de usuario

userRoutes.get("/users", UsersController.getAll); 
userRoutes.get("/users/:id", UsersController.getById);
userRoutes.post("/users", UsersController.save);
userRoutes.put("/users/:id", UsersController.update); 
userRoutes.delete("/users/:id", UsersController.delete); 
