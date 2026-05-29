import { getFirestore } from "firebase-admin/firestore";
import { Instituicao } from "../models/instituicao.model";
import { NotFoundError } from "../errors/not-found.error";

export class InstituicaoService {

    async getAll(): Promise<Instituicao[]> {
        const snapshot = await getFirestore().collection("instituicoes").get();
        return snapshot.docs.map(doc => {
            return {
                id: doc.id,
                ...doc.data()
            }
        }) as Instituicao[];
    }

    async getById(id: string): Promise<Instituicao>{
        const doc = await getFirestore().collection("instituicoes").doc(id).get();
        if (doc.exists) {
            return{
                id: doc.id,
                ...doc.data()
            } as Instituicao;
        } else {
            throw new NotFoundError("Instituição não encontrada");
        }   
    }

    async save(instituicao: Instituicao): Promise<void>{
        await getFirestore().collection("instituicoes").add(instituicao);
    }

    async update (id: string, instituicao: Instituicao): Promise<void> {
        let docRef = getFirestore().collection("instituicoes").doc(id);

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
        getFirestore().collection("instituicoes").doc(id).delete();
    }
}