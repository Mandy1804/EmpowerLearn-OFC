import { Request, Response, NextFunction } from 'express';
import { MensagemService } from '../services/mensagem.service';

export class MensagemChatController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new MensagemService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new MensagemService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new MensagemService().save(req.body);
        res.status(201).send({ message: 'Mensagem enviada com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new MensagemService().update(id, req.body);
        res.send({ message: 'Mensagem atualizada com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new MensagemService().delete(id);
        res.status(204).end();
    }
}