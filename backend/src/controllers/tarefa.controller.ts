import { parseId } from '../utils/parse-id';
import { Request, Response, NextFunction } from 'express';
import { TarefaService } from '../services/tarefa.service';

export class TarefaController {
  static async getAll(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const materiaIdQuery = req.query.materiaId?.toString();
    const materiaId = materiaIdQuery ? Number(materiaIdQuery) : undefined;

    res.send(
      await new TarefaService().getAll(
        Number.isFinite(materiaId) && materiaId && materiaId > 0
          ? materiaId
          : undefined
      )
    );
  }

  static async getById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const id = parseId(req);
    res.send(await new TarefaService().getById(id));
  }

  static async save(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    await new TarefaService().save(req.body);
    res.status(201).send({ message: 'Tarefa criada com sucesso' });
  }

  static async update(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const id = parseId(req);
    await new TarefaService().update(id, req.body);
    res.send({ message: 'Tarefa atualizada com sucesso' });
  }

  static async delete(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const id = parseId(req);
    await new TarefaService().delete(id);
    res.status(204).end();
  }
}