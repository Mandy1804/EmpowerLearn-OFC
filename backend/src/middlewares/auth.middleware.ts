import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export function authMiddleware(req: Request, res: Response, next: NextFunction) {
    const authHeader = req.headers['authorization'];

    if (!authHeader) {
        return res.status(401).send({ message: 'Token não fornecido' });
    }

    const token = authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).send({ message: 'Token mal formatado' });
    }

    try {
        const payload = jwt.verify(token, process.env.JWT_SECRET as string) as { userId: number; tipo: string };
        (req as any).userId = payload.userId;
        (req as any).userTipo = payload.tipo;
        next();
    } catch {
        return res.status(401).send({ message: 'Token inválido ou expirado' });
    }
}