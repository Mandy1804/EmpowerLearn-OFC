import { parseId } from '../utils/parse-id';
import { Request, Response, NextFunction } from 'express';
import { MateriaService } from '../services/materia.service';

export class MateriaController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new MateriaService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        res.send(await new MateriaService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new MateriaService().save(req.body);
        res.status(201).send({ message: 'Matéria criada com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new MateriaService().update(id, req.body);
        res.send({ message: 'Matéria atualizada com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new MateriaService().delete(id);
        res.status(204).end();
    }
}