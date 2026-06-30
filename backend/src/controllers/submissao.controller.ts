import { parseId } from '../utils/parse-id';
import { Request, Response, NextFunction } from 'express';
import { SubmissaoService } from '../services/submissao.service';

export class SubmissaoController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new SubmissaoService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        res.send(await new SubmissaoService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new SubmissaoService().save(req.body);
        res.status(201).send({ message: 'Submissão criada com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new SubmissaoService().update(id, req.body);
        res.send({ message: 'Submissão atualizada com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new SubmissaoService().delete(id);
        res.status(204).end();
    }
}