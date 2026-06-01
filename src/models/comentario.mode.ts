import { Joi } from "celebrate";

export type Comentario = {
    id: string;
    conteudo: string;
    forum_id: string;
    user_id: string;
    data_criacao: Date;
};

export const comentarioSchema = Joi.object().keys({
    conteudo: Joi.string().max(500).required(),
    forum_id: Joi.string().required(),
    user_id: Joi.string().required(),
});