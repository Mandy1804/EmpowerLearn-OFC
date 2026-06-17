import { TokenRepository } from "../repositories/token.repository";

export class TokenService {
    private repo = new TokenRepository();
    async getById(id: number) { return this.repo.getById(id); }
    async getByToken(token: string) { return this.repo.getByToken(token); }
    async save(data: any) { return this.repo.save(data); }
    async delete(id: number) { return this.repo.delete(id); }
}