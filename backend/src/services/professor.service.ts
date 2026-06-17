import { NotFoundError } from "../errors/not-found.error";
import { ProfessorRepository } from "../repositories/professor.repository";

export class ProfessorService {

    private professorRepository: ProfessorRepository;

    constructor(){
        this.professorRepository = new ProfessorRepository();
    }

    async getAll(){
        return this.professorRepository.getAll();
    }

    async getById(id: number){
        const professor = await this.professorRepository.getById(id);
        if(!professor){
            throw new NotFoundError("Professor não encontrado");
        }
        return professor;
    }

    async save(data: any){
        await this.professorRepository.save(data);
    }

    async update(id: number, data: any){
        await this.professorRepository.update(id, data);
    }

    async delete(id: number){
        await this.professorRepository.delete(id);
    }
}