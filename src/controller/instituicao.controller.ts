import { NextFunction, Request, Response } from "express";
import { getFirestore } from "firebase-admin/firestore";
import { NotFoundError } from "../errors/not-found.error";
import { ValidationError } from "../errors/validation.error";

type Instituicao = {
    id: string;
    razao_social: string;
    cnpj: string;
    email: string;
    telefone: string;
    endereco: string;
    inscricao_estadual: string;
}

export class InstituicaoController {
    static async getAll(req: Request, res: Response) {
        const snapshot = await getFirestore().collection("instituicoes").get();
        const instituicoes = snapshot.docs.map(doc => {
            return {
                id: doc.id,
                ...doc.data()
            }
        });
        res.send(instituicoes);
    }

    static async getById(req: Request, res: Response, next: NextFunction) {
        let instituicaoId = req.params.id;
        const doc = await getFirestore().collection("instituicoes").doc(instituicaoId).get();
        if (doc.exists) {
            res.send({
                id: doc.id,
                ...doc.data()
            });
        } else {
            throw new NotFoundError("Instituição não encontrada");
        }

    }

    static async save(req: Request, res: Response) {
        let instituicao = req.body;

        if (!instituicao.email || instituicao.email?.length === 0) {
            throw new ValidationError("O email é obrigatório");
        }

        const instituicaoSalvo = await getFirestore().collection("instituicoes").add(instituicao);
        res.send({
            message: `Instituição ${instituicaoSalvo.id} criaca com sucesso`
        });
    }

    static async update(req: Request, res: Response) {
        let instituicaoId = req.params.id;
        let instituicao = req.body as Instituicao;
        let docRef = getFirestore().collection("instituicoes").doc(instituicaoId);

        if ((await docRef.get()).exists) {
            await docRef.set({
                razao_social: instituicao.razao_social,
                cnpj: instituicao.cnpj,
                email: instituicao.email,
                telefone: instituicao.telefone,
                endereco: instituicao.endereco,
                inscricao_estadual: instituicao.inscricao_estadual
            });
            res.send({
                message: "instituição atualizada com sucesso"
            });
        } else {
            throw new NotFoundError("Instituição não encontrada");
        }
    }

    static delete(req: Request, res: Response) {
        let instituicaoId = req.params.id;

        getFirestore().collection("instituicoes").doc(instituicaoId).delete();

        res.send({
            message: "Instituição deletada"
        })
    }
}

