import { Joi } from "celebrate";

export type Plano ={
    id: string;
    nome: string;
    descricao: string;
    preco: number;
    beneficios: string;
    data_criacao: Date;
};

export const planoSchema = Joi.object().keys({
    nome: Joi.string().required(),
    descricao: Joi.string().required(),
    preco: Joi.number().required(),
    beneficios: Joi.string().required(),
});