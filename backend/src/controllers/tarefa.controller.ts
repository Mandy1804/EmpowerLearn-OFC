import { Request, Response, NextFunction } from 'express';
import { TarefaService } from '../services/tarefa.service';

export class TarefaController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new TarefaService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new TarefaService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new TarefaService().save(req.body);
        res.status(201).send({ message: 'Tarefa criada com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new TarefaService().update(id, req.body);
        res.send({ message: 'Tarefa atualizada com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new TarefaService().delete(id);
        res.status(204).end();
    }
}   