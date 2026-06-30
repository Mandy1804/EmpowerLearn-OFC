import { SubmissaoRepository } from "../repositories/submissao.repository";

export class SubmissaoService {
  private repo = new SubmissaoRepository();

  async getAll(tarefaId?: number) {
    return this.repo.getAll(tarefaId);
  }

  async getById(id: number) {
    return this.repo.getById(id);
  }

  async save(data: any) {
    return this.repo.save(data);
  }

  async update(id: number, data: any) {
    return this.repo.update(id, data);
  }

  async delete(id: number) {
    return this.repo.delete(id);
  }
}