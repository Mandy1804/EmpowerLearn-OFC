import { Joi } from "celebrate";

export type Nota = {
    id: string;
    user_id: string;
    professor_id: string;
    nota: number;
    atividade_id: string;
    data_criacao: Date;
};

export const notaSchema = Joi.object().keys({
    user_id: Joi.string().required(),
    professor_id: Joi.string().required(),
    atividade_id: Joi.string().required(),
    nota: Joi.number().min(0).max(10).required(),
});