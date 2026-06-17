import { Joi } from "celebrate";

export type Categoria = {
    id: string;
    nome: string;
    descricao: string;
    area: string;
    data_criacao: Date;
};

export const categoriaSchema = Joi.object().keys({
    nome: Joi.string().required(),
    descricao: Joi.string().required(),
    area: Joi.string().required(),
});