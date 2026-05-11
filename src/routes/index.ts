import express from "express";
import { userRoutes  } from "./users.route";

export const routes = (app: express.Express) => { //ele é quem gerencia todas as nossas rotas 
    app.use(express.json()); //o app usa o express.json para formato de comuniçação 
    app.use(userRoutes); //aqui dizemos que o userroutes é quem vai gerenciar as rotas dos usuario
}