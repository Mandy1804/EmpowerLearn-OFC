import { ProgressoRepository } from "../repositories/progresso.repositories";

export class ProgressoService {
    private repo = new ProgressoRepository();
    async getAll() { return this.repo.getAll(); }
    async getById(id: number) { return this.repo.getById(id); }
    async save(data: any) { return this.repo.save(data); }
    async delete(id: number) { return this.repo.delete(id); }
}