import { InstituicaoRepository } from "../repositories/instituicao.repository";

export class InstituicaoService {
    private instituicaoRepository: InstituicaoRepository;
    constructor(){ this.instituicaoRepository = new InstituicaoRepository(); }
    async getAll() { return this.instituicaoRepository.getAll(); }
    async getById(id: number) { return this.instituicaoRepository.getById(id); }
    async save(data: any) { return this.instituicaoRepository.save(data); }
    async update(id: number, data: any) { return this.instituicaoRepository.update(id, data); }
    async delete(id: number) { return this.instituicaoRepository.delete(id); }
}