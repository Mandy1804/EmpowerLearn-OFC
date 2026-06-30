import { parseId } from "../utils/parse-id";
import { Request, Response, NextFunction } from "express";
import { MatriculaService } from "../services/matricula.service";

export class MatriculaController {
  static async getAll(req: Request, res: Response, next: NextFunction) {
    res.send(await new MatriculaService().getAll());
  }

  static async getById(req: Request, res: Response, next: NextFunction) {
    const id = parseId(req);
    res.send(await new MatriculaService().getById(id));
  }

  static async save(req: Request, res: Response, next: NextFunction) {
    const usuarioLogadoId = Number((req as any).userId);
    const tipoUsuario = String((req as any).userTipo ?? "");

    const cursoId = Number(req.body?.cursoId);
    const alunoId =
      tipoUsuario === "admin" && req.body?.alunoId
        ? Number(req.body.alunoId)
        : usuarioLogadoId;

    const matricula = await new MatriculaService().save({
      alunoId,
      cursoId,
    });

    res.status(201).send({
      message: "Matrícula criada com sucesso",
      matricula,
    });
  }

  static async delete(req: Request, res: Response, next: NextFunction) {
    const id = parseId(req);
    await new MatriculaService().delete(id);
    res.status(204).end();
  }
}
