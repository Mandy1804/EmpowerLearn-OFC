import { Request, Response, NextFunction } from 'express';
import { ProfessorService } from '../services/professor.service';

export class ProfessorControler {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new ProfessorService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new ProfessorService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new ProfessorService().save(req.body);
        res.status(201).send({ message: 'Professor criado com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new ProfessorService().update(id, req.body);
        res.send({ message: 'Professor atualizado com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new ProfessorService().delete(id);
        res.status(204).end();
    }
}