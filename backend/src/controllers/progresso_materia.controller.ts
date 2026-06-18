import { Request, Response, NextFunction } from 'express';
import { ProgressoService } from '../services/progresso.service';

export class ProgressoMateriaController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new ProgressoService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new ProgressoService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new ProgressoService().save(req.body);
        res.status(201).send({ message: 'Progresso registrado com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new ProgressoService().delete(id);
        res.status(204).end();
    }
}