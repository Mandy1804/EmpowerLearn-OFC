import express from "express";
import { UsersController } from "../controller/users.controller";
import asyncHandler  from "express-async-handler";

export const userRoutes = express.Router(); //um middleware para organizar as rotas de usuario

userRoutes.get("/users", asyncHandler(UsersController.getAll)); 
userRoutes.get("/users/:id", asyncHandler(UsersController.getById));
userRoutes.post("/users", asyncHandler(UsersController.save));
userRoutes.put("/users/:id", asyncHandler(UsersController.update)); 
userRoutes.delete("/users/:id", asyncHandler(UsersController.delete)); 
