import { NextFunction, Request, Response } from "express";
import { Professor } from "../models/professor.model";
import { ProfessorService } from "../services/professor.service";
export class ProfessorControler {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new ProfessorService().getAll());
    }


    static async getById(req: Request, res: Response, next: NextFunction) {
        let professorId = req.params["id"] as string;
        res.send(await new ProfessorService().getById(professorId))
    }

    static async save(req: Request, res: Response, next: NextFunction) {
        await new ProfessorService().save(req.body);
        res.send({
            message: `Professor foi criado com sucesso`
        })
    }

    static async update(req: Request, res: Response, next: NextFunction) {
        let professorId = req.params["id"] as string;
        let professor = req.body as Professor;
        await new ProfessorService().update(professorId, professor);
        res.send({
            message: "Dados do Professor, atualizados com sucesso"
        });
    }

    static async delete(req: Request, res: Response, next: NextFunction) {
        let professorId = req.params["id"] as string;
        await new ProfessorService().delete(professorId);
        res.status(204).end();
    }
}