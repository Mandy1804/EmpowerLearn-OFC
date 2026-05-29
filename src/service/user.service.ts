import { getFirestore } from "firebase-admin/firestore";
import { User } from "../models/users.model";
import { NotFoundError } from "../errors/not-found.error";

export class UserService {

    async getAll(): Promise<User[]> {
        const snapshot = await getFirestore().collection("users").get(); //aqui estamos pegando a colecao de usuarios do firestore e usando o metodo get para obter os dados
        return snapshot.docs.map(doc => { //
            return {
                id: doc.id,
                ...doc.data()
            };
        }) as User[];  
    }
    
    async getById(id: string): Promise<User>{
        const doc = await getFirestore().collection("users").doc(id).get(); //aqui estamos pegando a colecao de usuarios do firestore, usando o doc para pegar os dados/documentos e o get para mostrar os dados pelo id
        if (doc.exists) {
            return {
                id: doc.id,
                ...doc.data()
            } as User;
        }else {
                throw new NotFoundError("Usuario não foi encontrado");
        }//retorna o usuario buscado
    }

    async save(user: User): Promise<void> {
        await getFirestore().collection("users").add(user);
    }

    async update(id: string, user: User): Promise<void>{
        const docRef = getFirestore().collection("users").doc(id);

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
      getFirestore().collection("users").doc(id).delete();
    }
}