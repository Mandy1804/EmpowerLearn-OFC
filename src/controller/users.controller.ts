import { NextFunction, Request, Response } from 'express';
import { getFirestore } from 'firebase-admin/firestore';
import { ValidationError } from '../errors/validation.error';
import { NotFoundError } from '../errors/not-found.error';


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
  static async getAll(req: Request, res: Response, next: NextFunction) {
    const snapshot = await getFirestore().collection("users").get();
    const users = snapshot.docs.map(doc => {
      return {
        id: doc.id,
        ...doc.data()
      }
    });
    res.send(users);
  }

  static async getById(req: Request, res: Response, next: NextFunction) {
    let userId = req.params.id;
    const doc = await getFirestore().collection("users").doc(userId).get();
    if (doc.exists) {
      res.send({
        id: doc.id,
        ...doc.data()
      });
    } else {
      throw new NotFoundError("Usuario não encontrado");
    }
  }

  static async save(req: Request, res: Response, next: NextFunction) {
    let user = req.body;

    if (!user.email || user.email?.length === 0) {
      throw new ValidationError("O email é obrigatório");
    }

    const userSalvo = await getFirestore().collection("users").add(user);
    res.send({
      message: `Usuario ${userSalvo.id} foi criado com sucesso`
    });
  }

  static async update(req: Request, res: Response, next: NextFunction) {
    let userId = req.params.id;
    let user = req.body as User;
    let docRef = getFirestore().collection("users").doc(userId);

    if ((await docRef.get()).exists) {
      await docRef.set({
        nome: user.nome,
        idade: user.idade,
        email: user.email,
        data_nascimento: user.data_nascimento,
      });
      res.send({
        message: "Dados do Usuario, atualizados com sucesso"
      });
    } else {
      throw new NotFoundError("Usuario não encontrado");
    }
  }

  static delete(req: Request, res: Response, next: NextFunction) {
    let userId = req.params.id;

    getFirestore().collection("users").doc(userId).delete();

    res.send({
      message: "O Usuario foi deletado",
    });
  }

}