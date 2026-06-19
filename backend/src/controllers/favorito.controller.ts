import { Request, Response, NextFunction } from 'express';
import { FavoritoService } from '../services/favorito.service';

export class FavoritoController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new FavoritoService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new FavoritoService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new FavoritoService().save(req.body);
        res.status(201).send({ message: 'Favorito adicionado com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new FavoritoService().delete(id);
        res.status(204).end();
    }
}