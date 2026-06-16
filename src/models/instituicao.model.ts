import { Joi } from "celebrate";

export type Instituicao = {
    id: string;
    razao_social: string;
    cnpj: string;
    email: string;
    telefone: string;
    endereco: string;
    inscricao_estadual: string;
}

export const instituicaoSchema = Joi.object().keys({
    razao_social: Joi.string().required(),
    cnpj: Joi.string().required(),
    email: Joi.string().email().required(),
    telefone: Joi.string().required(),
    endereco: Joi.string().required(),
    inscricao_estadual: Joi.string().required(),
})