import express from 'express';
import { PlanoController } from '../controllers/plano.controller';
import asyncHandler from 'express-async-handler';

export const planoRoutes = express.Router();

planoRoutes.get('/planos', asyncHandler(PlanoController.getAll));
planoRoutes.get('/planos/:id', asyncHandler(PlanoController.getById));
planoRoutes.post('/planos', asyncHandler(PlanoController.save));
planoRoutes.put('/planos/:id', asyncHandler(PlanoController.update));
planoRoutes.delete('/planos/:id', asyncHandler(PlanoController.delete));    