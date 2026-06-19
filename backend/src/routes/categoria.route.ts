import express from 'express';
import { CategoriaController } from '../controllers/categoria.controller';
import asyncHandler from 'express-async-handler';

export const categoriaRoutes = express.Router();

categoriaRoutes.get('/categorias', asyncHandler(CategoriaController.getAll));
categoriaRoutes.get('/categorias/:id', asyncHandler(CategoriaController.getById));
categoriaRoutes.post('/categorias', asyncHandler(CategoriaController.save));
categoriaRoutes.put('/categorias/:id', asyncHandler(CategoriaController.update));
categoriaRoutes.delete('/categorias/:id', asyncHandler(CategoriaController.delete));