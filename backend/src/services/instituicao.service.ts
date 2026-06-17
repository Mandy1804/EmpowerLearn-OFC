import { NotFoundError } from "../errors/not-found.error";
import { InstituicaoRepository } from "../repositories/instituicao.repository";

export class InstituicaoService {

    private instituicaoRepository: InstituicaoRepository;

    constructor(){
        this.instituicaoRepository = new InstituicaoRepository();
    }

    async getAll(){
        return this.instituicaoRepository.getAll();
    }

    async getById(id: number){
        const instituicao = await this.instituicaoRepository.getById(id);
        if(!instituicao){
            throw new NotFoundError("Instituição não encontrada");
        }
        return instituicao;
    }

    async save(data: any){
        await this.instituicaoRepository.save(data);
    }

    async update(id: number, data: any){
        await this.instituicaoRepository.update(id, data);
    }

    async delete(id: number){
        await this.instituicaoRepository.delete(id);
    }
}