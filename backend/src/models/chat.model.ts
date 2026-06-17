import { Joi } from "celebrate";

export type Mensagem ={
    id: string;
    user_id: string;
    professor_id: string;
    conteudo: string;
    data_criacao: Date;
};

export const chatSchema = Joi.object().keys({
    user_id: Joi.string().required(),
    professor_id: Joi.string().required(),
    conteudo: Joi.string().max(1000).required(),
});