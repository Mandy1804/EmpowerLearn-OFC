import { MatriculaRepository } from "../repositories/matricula.repository";

export class MatriculaService {
    private repo = new MatriculaRepository();
    async getAll() { return this.repo.getAll(); }
    async getById(id: number) { return this.repo.getById(id); }
    async save(data: any) { return this.repo.save(data); }
    async delete(id: number) { return this.repo.delete(id); }
}