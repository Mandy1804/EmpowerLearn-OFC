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
        if (!user){
           throw new NotFoundError("Usuario não encontrado");
        }
        return user;
    }

    async save(data: any) {
        await this.userRepository.save(data);
    }

    async update(id: number, data: any) {
        return this.userRepository.update(id, data);
    }

    async delete(id: number) {
        await this.userRepository.delete(id);
    }
}