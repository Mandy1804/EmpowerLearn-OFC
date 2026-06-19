import { Request, Response, NextFunction } from 'express';
import { ValidationError } from '../errors/validation.error';

export function parseId(req: Request): number {
    const id = Number(req.params['id']);
    if (isNaN(id) || id <= 0) {
        throw new ValidationError('ID inválido');
    }
    return id;
}