import { Request, Response, NextFunction } from 'express';
import { InstituicaoService } from '../services/instituicao.service';

export class InstituicaoController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new InstituicaoService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new InstituicaoService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new InstituicaoService().save(req.body);
        res.status(201).send({ message: 'Instituição criada com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new InstituicaoService().update(id, req.body);
        res.send({ message: 'Instituição atualizada com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new InstituicaoService().delete(id);
        res.status(204).end();
    }
}