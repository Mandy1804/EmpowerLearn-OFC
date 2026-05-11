"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.UsersController = void 0;
let id = 0; //definimos que id comeca com 0 (bem basico)
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
        req.body; //pega as informacoes inseridas no body
        let user = req.body; //cria a variavel user e atribui o valor do body
        user.id = ++id; // o ++ é incremento de id para cada usuario criado
        usuarios.push(user); //adiciona o valor de user para o array
        res.send({
            message: "O usuario foi criado com sucesso",
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