import { Request, Response, NextFunction } from 'express';
import { UserService } from '../services/user.service';

export class UsersController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new UserService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new UserService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new UserService().save(req.body);
        res.status(201).send({ message: 'Usuario criado com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new UserService().update(id, req.body);
        res.send({ message: 'Usuario atualizado com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new UserService().delete(id);
        res.status(204).end();
    }
}