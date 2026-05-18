import { Request, Response} from "express";
import { getFirestore } from "firebase-admin/firestore";




type Professor = {
    id: string;
    nome: string;
    cpf : string;
    rg: string;
    idade: string;
    email: string;
    telefone: string;
    data_nascimento: Date;
    endereco: string;

    disciplina: string;
    formacao_academica: string;
};

export class ProfessorControler{
    static async getAll (req: Request, res: Response){
        const snapshot = await getFirestore().collection("professores").get();
        const professores =  snapshot.docs.map(doc => {
            return{
                id: doc.id,
                ...doc.data()
            }
        });
        res.send(professores); 
    }


    static async getById (req: Request, res: Response ){
        let professorId = req.params.id;
        const doc = await getFirestore().collection("professores").doc(professorId).get();
        res.send({
            id: doc.id,
            ...doc.data()
        })
    }

    static async save (req: Request, res: Response){
        let professor = req.body;
        const professorSalvo = await getFirestore().collection("professores").add(professor);
        res.send({
            message: `Professor ${professorSalvo.id} foi criado com sucesso`
        })
    }

    static update (req: Request, res: Response){
        let professorId = req.params.id;
        let professor = req.body as Professor;
        
        getFirestore().collection("professores").doc(professorId).set({
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
} 

    static delete (req: Request, res: Response){
        let professorId = req.params.id;

        getFirestore().collection("professores").doc(professorId).delete();

        res.send({
            message: "O Professor foi deletado",
        })
    }
}