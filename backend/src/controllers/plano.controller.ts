import { Request, Response, NextFunction } from 'express';
import { PlanoService } from '../services/plano.service';

export class PlanoController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new PlanoService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new PlanoService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new PlanoService().save(req.body);
        res.status(201).send({ message: 'Plano criado com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new PlanoService().update(id, req.body);
        res.send({ message: 'Plano atualizado com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new PlanoService().delete(id);
        res.status(204).end();
    }
}