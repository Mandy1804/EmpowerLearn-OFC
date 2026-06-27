import { parseId } from '../utils/parse-id';
import { Request, Response, NextFunction } from 'express';
import { UserService } from '../services/user.service';

export class UsersController {
    static async getAll(req: Request, res: Response, next: NextFunction): Promise<void> {
        res.send(await new UserService().getAll());
    }

    static async getById(req: Request, res: Response, next: NextFunction): Promise<void> {
        const id = parseId(req);
        res.send(await new UserService().getById(id));
    }

    static async getMe(req: Request, res: Response, next: NextFunction): Promise<void> {
        const userId = (req as any).userId;
        const perfil = await new UserService().getMeuPerfil(userId);

        res.send(perfil);
    }

    static async save(req: Request, res: Response, next: NextFunction): Promise<void> {
        await new UserService().save(req.body);
        res.status(201).send({ message: 'Usuario criado com sucesso' });
    }

    static async update(req: Request, res: Response, next: NextFunction): Promise<void> {
        const id = parseId(req);
        await new UserService().update(id, req.body);
        res.send({ message: 'Usuario atualizado com sucesso' });
    }

    static async updateMe(req: Request, res: Response, next: NextFunction): Promise<void> {
        const userId = (req as any).userId;
        const perfil = await new UserService().updateMeuPerfil(userId, req.body);

        res.send({
            message: 'Perfil atualizado com sucesso',
            user: perfil
        });
    }

    static async uploadFoto(req: Request, res: Response, next: NextFunction): Promise<void> {
        const userId = (req as any).userId;
        const file = req.file;

        if (!file) {
            res.status(400).send({ message: 'Nenhuma imagem foi enviada' });
            return;
        }

        const protocolo = req.get('x-forwarded-proto') || req.protocol;
        const host = req.get('host');

        const fotoUrl = `${protocolo}://${host}/uploads/perfil/${file.filename}`;

        const perfil = await new UserService().updateFotoPerfil(userId, fotoUrl);

        res.send({
            message: 'Foto de perfil atualizada com sucesso',
            fotoUrl,
            user: perfil
        });
    }

    static async delete(req: Request, res: Response, next: NextFunction): Promise<void> {
        const id = parseId(req);
        await new UserService().delete(id);
        res.status(204).end();
    }
}
