import { CollectionReference, getFirestore } from "firebase-admin/firestore";
import { User } from "../models/users.model";
import { NotFoundError } from "../errors/not-found.error";

export class UserRepository {

    private collection: CollectionReference;
    constructor(){
        this.collection = getFirestore().collection("users");
    }
    async getAll(): Promise<User[]> {
        const snapshot = await this.collection.get(); //aqui estamos pegando a colecao de usuarios do firestore e usando o metodo get para obter os dados
        return snapshot.docs.map(doc => { 
            return {
                id: doc.id,
                ...doc.data()
            };
        }) as User[];  
    }

    async getById(id: string): Promise<User | null> {
        const doc = await this.collection.doc(id).get(); //aqui estamos pegando a colecao de usuarios do firestore, usando o doc para pegar os dados/documentos e o get para mostrar os dados pelo id
        if (doc.exists) {
            return {
                id: doc.id,
                ...doc.data()
            } as User;
        }else {
            return null;
        }//retorna o usuario buscado
    }

    async save(user: User): Promise<void>{
        await this.collection.add(user);
    }

    async update (id: string, user: User): Promise<void>{
        const docRef = this.collection.doc(id);

        if ((await docRef.get()).exists) {
            await docRef.set({
                nome: user.nome,
                cpf: user.cpf,
                idade: user.idade,
                email: user.email,
                telefone: user.telefone,
                data_nascimento: user.data_nascimento,
            });
        } else {
            throw new NotFoundError("Professor não encontrado");
        }
    }

    async delete(id: string): Promise<void>{
        await this.collection.doc(id).delete();
    }
}