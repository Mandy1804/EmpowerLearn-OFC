import { Request, Response, NextFunction } from 'express';
import { NotaService } from '../services/nota.service';

export class NotaAlunoController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new NotaService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new NotaService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new NotaService().save(req.body);
        res.status(201).send({ message: 'Nota criada com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new NotaService().update(id, req.body);
        res.send({ message: 'Nota atualizada com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new NotaService().delete(id);
        res.status(204).end();
    }
}