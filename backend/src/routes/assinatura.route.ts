import express from 'express';
import { AssinaturaController } from '../controllers/assinatura.controller';
import asyncHandler from 'express-async-handler';

export const assinaturaRoutes = express.Router();

assinaturaRoutes.get('/assinaturas', asyncHandler(AssinaturaController.getAll));
assinaturaRoutes.get('/assinaturas/:id', asyncHandler(AssinaturaController.getById));
assinaturaRoutes.post('/assinaturas', asyncHandler(AssinaturaController.save));
assinaturaRoutes.put('/assinaturas/:id', asyncHandler(AssinaturaController.update));
assinaturaRoutes.delete('/assinaturas/:id', asyncHandler(AssinaturaController.delete));