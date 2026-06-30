import { Joi } from "celebrate";

export type User = {
  id: string;
  nome: string;
  cpf: string;
  idade: number;
  email: string;
  telefone: string;
  data_nascimento: Date;
};

export const userSchema = Joi.object().keys({
    nome: Joi.string().required(),
    cpf: Joi.string().required(),
    idade: Joi.number().required(),
    email: Joi.string().email().required(),
    telefone: Joi.string().required(),
    data_nascimento: Joi.string().required(),
});

export const userProfileUpdateSchema = Joi.object().keys({
    nome: Joi.string().min(2).max(120).optional(),
    fotoUrl: Joi.string().allow('', null).optional(),
}).min(1);
