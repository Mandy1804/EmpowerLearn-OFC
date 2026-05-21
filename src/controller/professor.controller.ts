import { NextFunction, Request, Response } from "express";
import { getFirestore } from "firebase-admin/firestore";
import { NotFoundError } from "../errors/not-found.error";
import { ValidationError } from "../errors/validation.error";




type Professor = {
    id: string;
    nome: string;
    cpf: string;
    rg: string;
    idade: string;
    email: string;
    telefone: string;
    data_nascimento: Date;
    endereco: string;

    disciplina: string;
    formacao_academica: string;
};

export class ProfessorControler {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        const snapshot = await getFirestore().collection("professores").get();
        const professores = snapshot.docs.map(doc => {
            return {
                id: doc.id,
                ...doc.data()
            }
        });
        res.send(professores);
    }


    static async getById(req: Request, res: Response, next: NextFunction) {
        let professorId = req.params.id;
        const doc = await getFirestore().collection("professores").doc(professorId).get();
        if (doc.exists) {
            res.send({
                id: doc.id,
                ...doc.data()
            });
        } else {
            throw new NotFoundError("Professor não foi encontrado");
        }
    }

    static async save(req: Request, res: Response, next: NextFunction) {
        let professor = req.body;

        if (!professor.email || professor.email?.legth === 0) {
            throw new ValidationError("O email é obrigatório");
        }

        const professorSalvo = await getFirestore().collection("professores").add(professor);
        res.send({
            message: `Professor ${professorSalvo.id} foi criado com sucesso`
        })
    }

    static async update(req: Request, res: Response, next: NextFunction) {
        let professorId = req.params.id;
        let professor = req.body as Professor;
        const docRef = getFirestore().collection("professores").doc(professorId);

        if ((await docRef.get()).exists) {
            await docRef.set({
                nome: professor.nome,
                cpf: professor.cpf,
                rg: professor.rg,
                idade: professor.idade,
                email: professor.email,
                telefone: professor.telefone,
                data_nascimento: professor.data_nascimento,
                endereco: professor.endereco,
                disciplina: professor.disciplina,
                formacao_academica: professor.formacao_academica
            });
            res.send({
                message: "Dados do Professor, atualizados com sucesso"
            });
        } else {
            throw new NotFoundError("Professor não encontrado");
        }
    }

    static delete(req: Request, res: Response, next: NextFunction) {
        let professorId = req.params.id;

        getFirestore().collection("professores").doc(professorId).delete();

        res.send({
            message: "O Professor foi deletado",
        })
    }
}