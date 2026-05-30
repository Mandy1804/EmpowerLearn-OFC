import { Professor } from "../models/professor.model";
import { NotFoundError } from "../errors/not-found.error";
import { ProfessorRepository } from "../repositorys/professor.repository";

export class ProfessorService {

    private professorRepository: ProfessorRepository;

    constructor(){
        this.professorRepository = new ProfessorRepository;
    }

    async getAll(): Promise<Professor[]>{
        return this.professorRepository.getAll()
    }

    async getById(id: string): Promise<Professor>{
        const professor = await this.professorRepository.getById(id);
        if(!professor){
            throw new NotFoundError("Professor não encontrado")
        }
        return professor;
    }

    async save(professor: Professor): Promise<void>{
        await this.professorRepository.save(professor);
    }

    async update(id: string, professor: Professor): Promise<void> {
        await this.professorRepository.update(id, professor);
    }

    async delete(id: string): Promise<void>{
        await this.professorRepository.delete(id);
    }
}