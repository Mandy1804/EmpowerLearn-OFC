import { Request, Response, NextFunction } from 'express';
import { AuthService } from '../services/auth.service';

export class AuthController {

    static async register(req: Request, res: Response, next: NextFunction) {
        await new AuthService().register(req.body);
        res.status(201).send({ message: 'Usuário cadastrado com sucesso' });
    }

    static async login(req: Request, res: Response, next: NextFunction) {
        const { email, senha } = req.body;
        const resultado = await new AuthService().login(email, senha);
        res.status(200).send(resultado);
    }

    static async refresh(req: Request, res: Response, next: NextFunction) {
        const { token } = req.body;
        const resultado = await new AuthService().refreshToken(token);
        res.status(200).send(resultado);
    }
}