import { Joi } from "celebrate";

export type Notificacoes ={
    id: string;
    user_id: string;
    professor_id: string;
    titulo: string;
    descricao: string;
    lida: boolean;
    data_criacao: Date;
};

export const notificacoesSchema = Joi.object().keys({
    user_id: Joi.string().required(),
    professor_id: Joi.string().required(),
    titulo: Joi.string().required(),
    descricao: Joi.string().required(),
    lida: Joi.boolean().required(), 
});