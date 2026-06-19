import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { UserRepository } from '../repositories/user.repository';
import prisma from '../config/prisma';
import { ValidationError } from '../errors/validation.error';

export class AuthService {

    private userRepository: UserRepository;

    constructor() {
        this.userRepository = new UserRepository();
    }

    async register(data: any) {
        const emailExistente = await this.userRepository.findByEmail(data.email);
        if (emailExistente) {
            throw new ValidationError('Email já cadastrado');
        }
        const senhaHash = await bcrypt.hash(data.senha, 10);
        return this.userRepository.save({
            nome: data.nome,
            email: data.email,
            senhaHash,
            tipo: data.tipo,
        });
    }

    async login(email: string, senha: string) {
        const user = await this.userRepository.findByEmail(email);
        if (!user) {
            throw new Error('Credenciais inválidas');
        }
        const senhaCorreta = await bcrypt.compare(senha, user.senhaHash);
        if (!senhaCorreta) {
            throw new Error('Credenciais inválidas');
        }
        const token = jwt.sign(
            { userId: user.id, tipo: user.tipo },
            process.env.JWT_SECRET as string,
            { expiresIn: '1h' }
        );
        const refreshToken = await this.generateRefreshToken(user.id);

        return {
            token,
            refreshToken: refreshToken.token,
            usuario: { id: user.id, nome: user.nome, email: user.email, tipo: user.tipo }
        };
    }

    async generateRefreshToken(userId: number) {
        const token = jwt.sign(
            { userId },
            process.env.JWT_REFRESH_SECRET as string,
            { expiresIn: '7d' }
        );
        const expiraEm = new Date();
        expiraEm.setDate(expiraEm.getDate() + 7);

        return prisma.refreshToken.create({
            data: { token, usuarioId: userId, expiraEm }
        });
    }

    async refreshToken(token: string) {
        const tokenSalvo = await prisma.refreshToken.findUnique({
            where: { token }
        });

        if (!tokenSalvo) {
            throw new ValidationError('Refresh token inválido');
        }

        if (tokenSalvo.expiraEm < new Date()) {
            throw new ValidationError('Refresh token expirado');
        }

        const payload = jwt.verify(
            token,
            process.env.JWT_REFRESH_SECRET as string
        ) as { userId: number };

        const novoToken = jwt.sign(
            { userId: payload.userId },
            process.env.JWT_SECRET as string,
            { expiresIn: '1h' }
        );

        return { token: novoToken };
    }
}