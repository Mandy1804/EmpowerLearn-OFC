import express from 'express';
import { HistoricoController } from '../controllers/historico.controller';
import asyncHandler from 'express-async-handler';

export const historicoRoutes = express.Router();

historicoRoutes.get('/historicos', asyncHandler(HistoricoController.getAll));
historicoRoutes.get('/historicos/:id', asyncHandler(HistoricoController.getById));
historicoRoutes.post('/historicos', asyncHandler(HistoricoController.save));
historicoRoutes.delete('/historicos/:id', asyncHandler(HistoricoController.delete));