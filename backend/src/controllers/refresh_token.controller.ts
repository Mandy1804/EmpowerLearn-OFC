import { parseId } from '../utils/parse-id';
import { Request, Response, NextFunction } from 'express';
import { TokenService } from '../services/token.service';

export class RefreshTokenController {
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        res.send(await new TokenService().getById(id));
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new TokenService().delete(id);
        res.status(204).end();
    }
}