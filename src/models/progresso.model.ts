import { Joi } from "celebrate";

export type Progresso = {
    id: string;
    user_id: string;
    videoaula_id: string;
    tempo_assistido: number;
    concluido: boolean;
    data_criacao: Date;
};

export const progressoSchema = Joi.object().keys({
    user_id: Joi.string().required(),
    videoaula_id: Joi.string().required(),
    tempo_assistido: Joi.number().required(),
    concluido: Joi.boolean().required(),
});