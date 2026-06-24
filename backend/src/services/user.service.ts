import { UserRepository } from "../repositories/user.repository";
import { NotFoundError } from "../errors/not-found.error";

export class UserService {

    private userRepository: UserRepository;

    constructor() {
        this.userRepository = new UserRepository();
    }

    async getAll() {
        return this.userRepository.getAll();
    }

    async getById(id: number) {
        const user = await this.userRepository.getById(id);

        if (!user) {
            throw new NotFoundError("Usuario não encontrado");
        }

        return user;
    }

    async getMeuPerfil(id: number) {
        return this.userRepository.getPerfilById(id);
    }

    async save(data: any) {
        await this.userRepository.save(data);
    }

    async update(id: number, data: any) {
        return this.userRepository.update(id, data);
    }

    async updateMeuPerfil(id: number, data: any) {
        const dadosPermitidos: any = {};

        if (data.nome !== undefined) {
            dadosPermitidos.nome = data.nome;
        }

        if (data.fotoUrl !== undefined) {
            dadosPermitidos.fotoUrl = data.fotoUrl || null;
        }

        return this.userRepository.updatePerfil(id, dadosPermitidos);
    }

    async updateFotoPerfil(id: number, fotoUrl: string) {
        return this.userRepository.updatePerfil(id, { fotoUrl });
    }

    async delete(id: number) {
        await this.userRepository.delete(id);
    }
}
