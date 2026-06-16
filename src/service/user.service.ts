import { User } from "../models/users.model";
import { UserRepository } from "../repositorys/user.repository";
import { NotFoundError } from "../errors/not-found.error";

export class UserService {

    private userRepository: UserRepository;

    constructor() {
        this.userRepository = new UserRepository();
    }

    async getAll(): Promise<User[]> {
        return this.userRepository.getAll();
    }

    async getById(id: string): Promise<User>{
        const user = await this.userRepository.getById(id);
        if (!user){
           throw new NotFoundError("Usuario não encontrado")
        }
        return user;
    }

    async save(user: User): Promise<void> {
        await this.userRepository.save(user);
    }

    async update(id: string, user: User): Promise<void>{
        return this.userRepository.update(id, user);
    }

    async delete(id: string): Promise<void>{
        await this.userRepository.delete(id);
    }
}