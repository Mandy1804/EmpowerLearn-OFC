import { Joi } from "celebrate";

export type Historico ={
    id: string;
    user_id: string;
    videoaula_id: string;
    assistindo_em: Date;
};

export const historicoSchema =  Joi.object().keys({
    user_id: Joi.string().required(),
    videoaula_id: Joi.string().required(),
});