import { Request } from 'express';

export function parseId(req: Request): number {
    const id = req.params['id'];
    return parseInt(Array.isArray(id) ? id[0] : id);
}