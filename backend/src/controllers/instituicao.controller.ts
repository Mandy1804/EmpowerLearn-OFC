import { NextFunction, Request, Response } from "express";
import { Instituicao } from "../models/instituicao.model";
import { InstituicaoService } from "../services/instituicao.service";
export class InstituicaoController {
    static async getAll(req: Request, res: Response) {
        res.send(await new InstituicaoService().getAll());
    }

    static async getById(req: Request, res: Response, next: NextFunction) {
        let instituicaoId = req.params.id;
        res.send(await new InstituicaoService().getById(instituicaoId)); //aqui estamos usando o instanceId para pegar o id da instituição e mostrar os dados da instituição buscada
    }

    static async save(req: Request, res: Response) {
        await new InstituicaoService().save(req.body);
        res.send({
            message: `Instituição criaca com sucesso`
        });
    }

    static async update(req: Request, res: Response) {
        let instituicaoId = req.params.id;
        let instituicao = req.body as Instituicao;
        await new InstituicaoService().update(instituicaoId, instituicao);
        res.send({
            message: "instituição atualizada com sucesso"
        });
    }

    static delete(req: Request, res: Response) {
        let instituicaoId = req.params.id;
        new InstituicaoService().delete(instituicaoId);
        res.status(204).end()
    }
}

