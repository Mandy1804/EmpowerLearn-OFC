import { parseId } from '../utils/parse-id';
import { Request, Response, NextFunction } from 'express';
import { ComentarioService } from '../services/comentario.service';

export class ComentarioController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new ComentarioService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        res.send(await new ComentarioService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new ComentarioService().save(req.body);
        res.status(201).send({ message: 'Comentário criado com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new ComentarioService().update(id, req.body);
        res.send({ message: 'Comentário atualizado com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new ComentarioService().delete(id);
        res.status(204).end();
    }
}