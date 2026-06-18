import { Request, Response, NextFunction } from 'express';
import { StripeService } from '../services/stripe.service';

const stripeService = new StripeService();

export class StripeController {

    static async criarCliente(req: Request, res: Response, next: NextFunction) {
        const { nome, email } = req.body;
        const cliente = await stripeService.criarCliente(nome, email);
        res.status(201).send(cliente);
    }

    static async listarPlanos(req: Request, res: Response, next: NextFunction) {
        const planos = await stripeService.listarPlanos();
        res.status(200).send(planos);
    }

    static async criarAssinatura(req: Request, res: Response, next: NextFunction) {
        const { customerId, priceId } = req.body;
        const assinatura = await stripeService.criarAssinatura(customerId, priceId);
        res.status(201).send(assinatura);
    }

    static async cancelarAssinatura(req: Request, res: Response, next: NextFunction) {
        const { subscriptionId } = req.body;
        const resultado = await stripeService.cancelarAssinatura(subscriptionId);
        res.status(200).send(resultado);
    }

    static async webhook(req: Request, res: Response, next: NextFunction) {
        const signature = req.headers['stripe-signature'] as string;

        try {
            const evento = await stripeService.construirEvento(req.body, signature);

            switch (evento.type) {
                case 'invoice.payment_succeeded':
                    console.log('Pagamento confirmado:', evento.data.object);
                    break;
                case 'customer.subscription.deleted':
                    console.log('Assinatura cancelada:', evento.data.object);
                    break;
                default:
                    console.log('Evento recebido:', evento.type);
            }

            res.status(200).send({ received: true });
        } catch (error) {
            res.status(400).send({ message: 'Webhook inválido' });
        }
    }
}