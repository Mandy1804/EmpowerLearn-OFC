"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.UsersController = void 0;
const firestore_1 = require("firebase-admin/firestore");
//definimos que id comeca com 0 (bem basico)
let usuarios = []; //aqui temos uma lista de usuarios 
class UsersController {
    static getAll(req, res) {
        res.send(usuarios);
    }
    static getById(req, res) {
        let userId = Number(req.params.id); //pega o id do parametro da url
        let user = usuarios.find(user => user.id === userId); //declara a variavel user e coloca o valor do usuario igual ao id do parametro 
        res.send(user); //retorna o usuario buscado 
    }
    static save(req, res) {
        return __awaiter(this, void 0, void 0, function* () {
            let user = req.body; //cria a variavel user e atribui o valor do body
            const userSalvo = yield (0, firestore_1.getFirestore)().collection("users").add(user);
            res.send({
                message: `Usuario ${userSalvo.id} foi criado com sucesso`,
            });
        });
    }
    static update(req, res) {
        let userId = Number(req.params.id); //obteve o id do usuario pelo parametro
        let user = req.body; // pegou as informacoes do corpo
        let indexOf = usuarios.findIndex((_user) => _user.id === userId); //procurou o index do usuario pelo id
        usuarios[indexOf].nome = user.nome; //atualizou o nome do usuario
        usuarios[indexOf].idade = user.idade; //atualizou a idade do usuario
        usuarios[indexOf].data_nascimento = user.data_nascimento; //atualizou a data de nascimento do usuario
        usuarios[indexOf].email = user.email; //atualizou o email do usuario
        res.send({
            message: "Usuario atyalizado com sucesso",
        });
    }
    static delete(req, res) {
        let userId = Number(req.params.id); //pega id do usuario pelo parametro
        let indexOf = usuarios.findIndex((user) => user.id === userId); //procura o usuario pelo id e retorna o index
        usuarios.splice(indexOf, 1); //splice é o metodo que remove o usuarios do array, o index é a posicao dele e o (, 1) remove um elemento
        res.send({
            message: "Usuarios deletado com sucesso",
        });
    }
}
exports.UsersController = UsersController;
//# sourceMappingURL=users.controller.js.map