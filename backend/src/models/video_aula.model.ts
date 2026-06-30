import { Joi } from "celebrate";

export type Videoaula = {
    id: string;
    titulo: string;
    descricao: string;
    url_video: string;
    thumbnail: string;
    data_criacao: Date;
    duracao: number;
    categoria_id: string;
    professor_id: string;
};

export const videoaulaSchema = Joi.object().keys({
    titulo: Joi.string().required(),
    descricao: Joi.string().required(),
    url_video: Joi.string().required(),
    thumbnail: Joi.string().required(),
    duracao: Joi.number().required(),
    categoria_id: Joi.string().required(),
    professor_id: Joi.string().required(),
});