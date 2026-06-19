import { Request, Response, NextFunction } from 'express';
import { NotificacaoService } from '../services/notificacao.service';

export class NotificacaoController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new NotificacaoService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new NotificacaoService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new NotificacaoService().save(req.body);
        res.status(201).send({ message: 'Notificação criada com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new NotificacaoService().update(id, req.body);
        res.send({ message: 'Notificação atualizada com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new NotificacaoService().delete(id);
        res.status(204).end();
    }
}