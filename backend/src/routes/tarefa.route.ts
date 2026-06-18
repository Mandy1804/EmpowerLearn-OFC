import express from 'express';
import { TarefaController } from '../controllers/tarefa.controller';
import asyncHandler from 'express-async-handler';

export const tarefaRoutes = express.Router();

tarefaRoutes.get('/tarefas', asyncHandler(TarefaController.getAll));
tarefaRoutes.get('/tarefas/:id', asyncHandler(TarefaController.getById));
tarefaRoutes.post('/tarefas', asyncHandler(TarefaController.save));
tarefaRoutes.put('/tarefas/:id', asyncHandler(TarefaController.update));
tarefaRoutes.delete('/tarefas/:id', asyncHandler(TarefaController.delete));