import express from 'express';
import { StripeController } from '../controllers/stripe.controller';
import asyncHandler from 'express-async-handler';

export const stripeRoutes = express.Router();

stripeRoutes.get('/stripe/planos', asyncHandler(StripeController.listarPlanos));
stripeRoutes.post('/stripe/clientes', asyncHandler(StripeController.criarCliente));
stripeRoutes.post('/stripe/assinaturas', asyncHandler(StripeController.criarAssinatura));
stripeRoutes.post('/stripe/assinaturas/cancelar', asyncHandler(StripeController.cancelarAssinatura));
stripeRoutes.post('/stripe/webhook', asyncHandler(StripeController.webhook));