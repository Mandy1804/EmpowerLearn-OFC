import express from 'express';
import { FavoritoController } from '../controllers/favorito.controller';
import asyncHandler from 'express-async-handler';

export const favoritoRoutes = express.Router();

favoritoRoutes.get('/favoritos', asyncHandler(FavoritoController.getAll));
favoritoRoutes.get('/favoritos/:id', asyncHandler(FavoritoController.getById));
favoritoRoutes.post('/favoritos', asyncHandler(FavoritoController.save));
favoritoRoutes.delete('/favoritos/:id', asyncHandler(FavoritoController.delete));