import { parseId } from '../utils/parse-id';
import { Request, Response, NextFunction } from 'express';
import { HistoricoService } from '../services/historico.service';

export class HistoricoController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new HistoricoService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        res.send(await new HistoricoService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new HistoricoService().save(req.body);
        res.status(201).send({ message: 'Histórico registrado com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new HistoricoService().delete(id);
        res.status(204).end();
    }
}