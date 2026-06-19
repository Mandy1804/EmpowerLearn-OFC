import express from 'express';
import { MensagemChatController } from '../controllers/mensagem_chat.controller';
import asyncHandler from 'express-async-handler';

export const mensagemRoutes = express.Router();

mensagemRoutes.get('/mensagens', asyncHandler(MensagemChatController.getAll));
mensagemRoutes.get('/mensagens/:id', asyncHandler(MensagemChatController.getById));
mensagemRoutes.post('/mensagens', asyncHandler(MensagemChatController.save));
mensagemRoutes.put('/mensagens/:id', asyncHandler(MensagemChatController.update));
mensagemRoutes.delete('/mensagens/:id', asyncHandler(MensagemChatController.delete));