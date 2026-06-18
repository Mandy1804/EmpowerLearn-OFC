import Stripe from 'stripe';

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY as string);

export class StripeService {

    async criarCliente(nome: string, email: string) {
        return await stripe.customers.create({ name: nome, email });
    }

    async listarPlanos() {
        const precos = await stripe.prices.list({ active: true, expand: ['data.product'] });
        return precos.data;
    }

    async criarAssinatura(customerId: string, priceId: string) {
        return await stripe.subscriptions.create({
            customer: customerId,
            items: [{ price: priceId }],
            payment_behavior: 'default_incomplete',
            expand: ['latest_invoice.payment_intent'],
        });
    }

    async cancelarAssinatura(subscriptionId: string) {
        return await stripe.subscriptions.cancel(subscriptionId);
    }

    async construirEvento(payload: Buffer, signature: string) {
        return stripe.webhooks.constructEvent(
            payload,
            signature,
            process.env.STRIPE_WEBHOOK_SECRET as string
        );
    }
}