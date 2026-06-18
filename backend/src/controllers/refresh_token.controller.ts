import { Request, Response, NextFunction } from 'express';
import { TokenService } from '../services/token.service';

export class RefreshTokenController {
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        res.send(await new TokenService().getById(id));
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = Number(req.params['id']);
        await new TokenService().delete(id);
        res.status(204).end();
    }
}