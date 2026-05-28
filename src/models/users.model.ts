import { Joi } from "celebrate";

export type User = { //estamos os tipos de dados
  id: string;
  nome: string;
  cpf: string;
  idade: number; 
  email: string;
  telefone: string;
  data_nascimento: Date;
};

export const userSchema = Joi.object().keys({  //informa as chaves que vao ser validadas, e quais validacoes de cada chave
    nome: Joi.string().required(), // required = obrigatorio
    cpf: Joi.string().required(),
    idade: Joi.number().required(),
    email: Joi.string().email().required(), //aqui o .email faz a validacao para modelo de email
    telefone: Joi.string().required(),
    data_nascimento: Joi.string().required(),
});
