import { CollectionReference, getFirestore } from "firebase-admin/firestore";
import { Professor } from "../models/professor.model";
import { NotFoundError } from "../errors/not-found.error";

export class ProfessorRepository{

    private collection: CollectionReference;
    constructor(){
        this.collection = getFirestore().collection("professores");
    }
    async getAll(): Promise<Professor[]>{
        const snapshot = await this.collection.get();
        return snapshot.docs.map(doc => {
            return {
                id: doc.id,
                ...doc.data()
            }
        }) as Professor[];
    }    

    async getById(id: string): Promise<Professor | null>{
        const doc = await this.collection.doc(id).get();
        if (doc.exists) {
            return{
                id: doc.id,
                ...doc.data()
            } as Professor;
        } else {
            return null;
        }
    }

    async save(professor: Professor): Promise<void>{
        await this.collection.add(professor);
    }

    async update(id: string, professor: Professor): Promise<void>{
        const docRef = this.collection.doc(id);

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
        this.collection.doc(id).delete();
    }
}