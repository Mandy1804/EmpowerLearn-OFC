import { getFirestore } from "firebase-admin/firestore";
import { Professor } from "../models/professor.model";
import { NotFoundError } from "../errors/not-found.error";

export class ProfessorService {

    async getAll(){
        const snapshot = await getFirestore().collection("professores").get();
        return snapshot.docs.map(doc => {
            return {
                id: doc.id,
                ...doc.data()
            }
        }) as Professor[];
    }

    async getById(id: string): Promise<Professor>{
        const doc = await getFirestore().collection("professores").doc(id).get();
        if (doc.exists) {
            return{
                id: doc.id,
                ...doc.data()
            } as Professor;
        } else {
            throw new NotFoundError("Professor não foi encontrado");
        }
    }

    async save(professor: Professor): Promise<void>{
        await getFirestore().collection("professores").add(professor);
    }

    async update(id: string, professor: Professor): Promise<void> {
        const docRef = getFirestore().collection("professores").doc(id);

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
        } else {
            throw new NotFoundError("Professor não encontrado");
        }
    }

    async delete(id: string): Promise<void>{
        getFirestore().collection("professores").doc(id).delete();
    }
}