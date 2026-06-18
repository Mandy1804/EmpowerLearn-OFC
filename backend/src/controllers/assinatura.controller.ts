import { Request, Response, NextFunction } from 'express';
import { AssinaturaService } from '../services/assinatura.service';

export class AssinaturaController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new AssinaturaService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new AssinaturaService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new AssinaturaService().save(req.body);
        res.status(201).send({ message: 'Assinatura criada com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new AssinaturaService().update(id, req.body);
        res.send({ message: 'Assinatura atualizada com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new AssinaturaService().delete(id);
        res.status(204).end();
    }
}