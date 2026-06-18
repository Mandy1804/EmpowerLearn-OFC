import { ProfessorRepository } from "../repositories/professor.repository";

export class ProfessorService {
    private professorRepository: ProfessorRepository;
    constructor(){ this.professorRepository = new ProfessorRepository(); }
    async getAll() { return this.professorRepository.getAll(); }
    async getById(id: number) { return this.professorRepository.getById(id); }
    async save(data: any) { return this.professorRepository.save(data); }
    async update(id: number, data: any) { return this.professorRepository.update(id, data); }
    async delete(id: number) { return this.professorRepository.delete(id); }
}