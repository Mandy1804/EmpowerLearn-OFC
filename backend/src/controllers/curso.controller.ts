import { parseId } from '../utils/parse-id';
import { Request, Response, NextFunction } from 'express';
import { CursoService } from '../services/curso.service';

export class CursoController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new CursoService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        res.send(await new CursoService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new CursoService().save(req.body);
        res.status(201).send({ message: 'Curso criado com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new CursoService().update(id, req.body);
        res.send({ message: 'Curso atualizado com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new CursoService().delete(id);
        res.status(204).end();
    }
}