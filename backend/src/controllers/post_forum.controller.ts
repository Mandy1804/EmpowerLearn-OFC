import { parseId } from '../utils/parse-id';
import { Request, Response, NextFunction } from 'express';
import { ForumService } from '../services/forum.service';

export class PostForumController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new ForumService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        res.send(await new ForumService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new ForumService().save(req.body);
        res.status(201).send({ message: 'Post criado com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new ForumService().update(id, req.body);
        res.send({ message: 'Post atualizado com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new ForumService().delete(id);
        res.status(204).end();
    }
}