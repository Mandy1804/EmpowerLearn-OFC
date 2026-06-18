import { ForumRepository } from "../repositories/forum.repository";

export class ForumService {
    private repo = new ForumRepository();
    async getAll() { return this.repo.getAll(); }
    async getById(id: number) { return this.repo.getById(id); }
    async save(data: any) { return this.repo.save(data); }
    async update(id: number, data: any) { return this.repo.update(id, data); }
    async delete(id: number) { return this.repo.delete(id); }
}