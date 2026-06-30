import { Joi } from "celebrate";

export type Atividade ={
    id: string;
    professor_id: string;
    user_id: string;
    categoria_id: string;
    nome: string;
    descricao: string;
    data_vencimento: Date;
    data_criacao: Date;
};

export const atividadeSchema = Joi.object().keys({
    professor_id: Joi.string().required(),
    user_id: Joi.string().required(),
    categoria_id: Joi.string().required(),
    nome: Joi.string().required(),
    descricao: Joi.string().required(),
    data_vencimento: Joi.date().required(),
});