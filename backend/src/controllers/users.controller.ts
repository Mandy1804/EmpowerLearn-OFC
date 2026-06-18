import { NextFunction, Request, Response } from 'express';    
import { User } from '../models/users.model';
import { UserService } from '../services/user.service';


//get: esse metodo retorna todos os usuarios
//post: esse metodo cria um novo usuario
//put: esse metodo atualiza os dados do usuario
//delete: esse metodo deleta o usuario

export class UsersController {
  static async getAll (req: Request, res: Response, next: NextFunction) { 
    res.send(await new UserService().getAll());
  }

  static async getById (req: Request, res: Response, next: NextFunction) { //esse metodo get é para retornar o usuario especifico por id
    let userId = req.params.id; //pega o id do parametro da url
    res.send(await new UserService().getById(userId)); //retorna o usuario buscado pelo id
  }

  static async save (req: Request, res: Response, next: NextFunction) { //esse é o metodo http que cria recebe a solicitacao do usuario
    await new UserService().save(req.body);
    res.status(201).send({
      message: `Usuario foi criado com sucesso`
    });
  }

  static async update (req: Request, res: Response, next: NextFunction) {
    let userId = req.params.id; //obteve o id do usuario pelo parametro
    let user = req.body as User; // pegou as informacoes do corpo
    await new UserService().update(userId, user);
    res.send({
      message: "Usuario alterado com sucesso"
    });
  }

  static async delete (req: Request, res: Response, next: NextFunction) {
    let userId = req.params.id;
    await new UserService().delete(userId);
    res.status(204).end();
  } 
}
