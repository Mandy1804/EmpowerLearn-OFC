import { Joi } from "celebrate";

export type Professor = {
    id: string;
    nome: string;
    cpf: string;
    rg: string;
    idade: string;
    email: string;
    telefone: string;
    data_nascimento: Date;
    endereco: string;

    disciplina: string;
    formacao_academica: string;
};

export const professorSchema = Joi.object().keys({
    nome: Joi.string().required(),
    cpf: Joi.string().required(),
    rg: Joi.string().required(),
    idade: Joi.number().required(),
    email: Joi.string().email().required(),
    telefone: Joi.string().required(),
    data_nascimento: Joi.string().required(),
    endereco: Joi.string().required(),

    disciplina: Joi.string().required(),
    formacao_academica: Joi.string().required(),
})