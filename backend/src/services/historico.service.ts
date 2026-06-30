import { HistoricoRepository } from "../repositories/historico.repository";

export class HistoricoService {
    private repo = new HistoricoRepository();
    async getAll() { return this.repo.getAll(); }
    async getById(id: number) { return this.repo.getById(id); }
    async save(data: any) { return this.repo.save(data); }
    async delete(id: number) { return this.repo.delete(id); }
}