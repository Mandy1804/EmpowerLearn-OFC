import { Joi } from "celebrate";

export type forum = {
    id: string;
    titulo: string;
    descricao: string;
    data_criacao: Date;
    user_id: string;
    categoria_id: string;
};

export const forumSchema = Joi.object().keys({
    titulo: Joi.string().max(100).required(),
    descricao: Joi.string().max(500).required(),
    categoria_id: Joi.string().required(),
    user_id:  Joi.string().required(),
});
