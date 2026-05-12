import { Request, Response } from 'express';    
import { getFirestore } from 'firebase-admin/firestore';


//get: esse metodo retorna todos os usuarios
//post: esse metodo cria um novo usuario
//put: esse metodo atualiza os dados do usuario
//delete: esse metodo deleta o usuario

type User = { //estamos os tipos de dados
  id: number;
  nome: string;
  idade: number; 
  data_nascimento: Date;
  email: string;
};

export class UsersController {
    static async getAll (req: Request, res: Response) {
      const snapshot = await getFirestore().collection("users").get(); //aqui estamos pegando a colecao de usuarios do firestore e usando o metodo get para obter os dados
      const users = snapshot.docs.map(doc => { //
        return {
          id: doc.id,
          ...doc.data()
        } 
      }); 
      res.send(users);
    }

    static async getById (req: Request, res: Response) { //esse metodo get é para retornar o usuario especifico por id
      let userId = req.params.id; //pega o id do parametro da url
      const doc = await getFirestore().collection("users").doc(userId).get(); //aqui estamos pegando a colecao de usuarios do firestore, usando o doc para pegar os dados/documentos e o get para mostrar os dados pelo id
      res.send({ 
        id: doc.id, 
        ...doc.data()
      }); //retorna o usuario buscado 
    }

    static async save (req: Request, res: Response) { //esse é o metodo http que cria recebe a solicitacao do usuario
      let user = req.body; //cria a variavel user e atribui o valor do body
      const userSalvo = await getFirestore().collection("users").add(user);
      res.send({
        message: `Usuario ${userSalvo.id} foi criado com sucesso`,
      });
    }

    static update (req: Request, res: Response) {
        let userId = req.params.id; //obteve o id do usuario pelo parametro
        let user = req.body as User; // pegou as informacoes do corpo
         
        getFirestore().collection("users").doc(userId).set({
          nome: user.nome,
          idade: user.idade,
          data_nascimento: user.data_nascimento,
          email: user.email
        });

        res.send({
            message: "Usuario atyalizado com sucesso",
        });
}

    static delete (req: Request, res: Response) {
        let userId = req.params.id;
        
        getFirestore().collection("users").doc(userId).delete();

        res.send({
            message: "Usuarios deletado com sucesso", 
        })
}

}