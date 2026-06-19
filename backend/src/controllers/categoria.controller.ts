import { Request, Response, NextFunction } from 'express';
import { CategoriaService } from '../services/categoria.service';

export class CategoriaController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new CategoriaService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new CategoriaService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new CategoriaService().save(req.body);
        res.status(201).send({ message: 'Categoria criada com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new CategoriaService().update(id, req.body);
        res.send({ message: 'Categoria atualizada com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new CategoriaService().delete(id);
        res.status(204).end();
    }
}