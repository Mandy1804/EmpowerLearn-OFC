import express from 'express';
import { ComentarioController } from '../controllers/comentario.controller';
import asyncHandler from 'express-async-handler';

export const comentarioRoutes = express.Router();

comentarioRoutes.get('/comentarios', asyncHandler(ComentarioController.getAll));
comentarioRoutes.get('/comentarios/:id', asyncHandler(ComentarioController.getById));
comentarioRoutes.post('/comentarios', asyncHandler(ComentarioController.save));
comentarioRoutes.put('/comentarios/:id', asyncHandler(ComentarioController.update));
comentarioRoutes.delete('/comentarios/:id', asyncHandler(ComentarioController.delete));