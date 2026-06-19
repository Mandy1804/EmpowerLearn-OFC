import { parseId } from '../utils/parse-id';
import { Request, Response, NextFunction } from 'express';
import { VideoService } from '../services/video.service';

export class VideoController {
    static async getAll(req: Request, res: Response, next: NextFunction) {
        res.send(await new VideoService().getAll());
    }
    static async getById(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        res.send(await new VideoService().getById(id));
    }
    static async save(req: Request, res: Response, next: NextFunction) {
        await new VideoService().save(req.body);
        res.status(201).send({ message: 'Vídeo criado com sucesso' });
    }
    static async update(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new VideoService().update(id, req.body);
        res.send({ message: 'Vídeo atualizado com sucesso' });
    }
    static async delete(req: Request, res: Response, next: NextFunction) {
        const id = parseId(req);
        await new VideoService().delete(id);
        res.status(204).end();
    }
}