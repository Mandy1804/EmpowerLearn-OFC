import { Request, Response, NextFunction } from 'express';
import { MatriculaService } from '../services/matricula.service';

export class MatriculaController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new MatriculaService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new MatriculaService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new MatriculaService().save(req.body);
        res.status(201).send({ message: 'Matrícula criada com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new MatriculaService().delete(id);
        res.status(204).end();
    }
}