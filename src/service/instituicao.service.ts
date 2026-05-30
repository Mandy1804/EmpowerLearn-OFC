import { Instituicao } from "../models/instituicao.model";
import { NotFoundError } from "../errors/not-found.error";
import { InstituicaoRepository } from "../repositorys/instituicao.repository";

export class InstituicaoService {

    private instituicaoRepository: InstituicaoRepository;

    constructor(){
        this.instituicaoRepository = new InstituicaoRepository;
    }

    async getAll(): Promise<Instituicao[]> {
        return this.instituicaoRepository.getAll();
    }

    async getById(id: string): Promise<Instituicao>{
        const instituicao = await this.instituicaoRepository.getById(id);
        if(!instituicao){
            throw new NotFoundError("Instituição não encontrada");
        }
        return instituicao;
    }

    async save(instituicao: Instituicao): Promise<void>{
        await this.instituicaoRepository.save(instituicao);
    }

    async update (id: string, instituicao: Instituicao): Promise<void> {
        await this.instituicaoRepository.update(id, instituicao);
    }

    async delete(id: string): Promise<void> {
        await this.instituicaoRepository.delete(id);
    }
}