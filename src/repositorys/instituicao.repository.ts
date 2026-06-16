import { CollectionReference, getFirestore } from "firebase-admin/firestore";
import { Instituicao } from "../models/instituicao.model";
import { NotFoundError } from "../errors/not-found.error";

export class InstituicaoRepository{

    private collection: CollectionReference;
    constructor(){
        this.collection = getFirestore().collection("instituicoes");
    }

    async getAll(): Promise<Instituicao[]> {
        const snapshot = await this.collection.get();
        return snapshot.docs.map(doc => {
            return {
                id: doc.id,
                ...doc.data()
            }
        }) as Instituicao[];
    }

    async getById(id: string): Promise<Instituicao | null>{
        const doc = await this.collection.doc(id).get();
        if (doc.exists) {
            return{
                id: doc.id,
                ...doc.data()
            } as Instituicao;
        } else {
            return null;
        }
    }
 
    async save(instituicao: Instituicao): Promise<void>{
        await this.collection.add(instituicao);
    }

    async update(id: string, instituicao: Instituicao): Promise<void>{
        const docRef = this.collection.doc(id);

        if ((await docRef.get()).exists) {
            await docRef.set({
                razao_social: instituicao.razao_social,
                cnpj: instituicao.cnpj,
                email: instituicao.email,
                telefone: instituicao.telefone,
                endereco: instituicao.endereco,
                inscricao_estadual: instituicao.inscricao_estadual
            });
        } else {
            throw new NotFoundError("Instituição não encontrada");
        }
    }

    async delete(id: string): Promise<void> {
        this.collection.doc(id).delete();
    }
}