import Express, { NextFunction, Request, Response } from "express";
import { NotFoundError } from "../errors/not-found.error";

export const pageNotFoundHandler = (app: Express.Express) => { 
    app.use((req: Request, res: Response , next: NextFunction) =>{
        next(new NotFoundError ("Pagina não encontrada"));
    });
};