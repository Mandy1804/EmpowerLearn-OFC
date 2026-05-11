import express from "express";
import { initializeApp } from "firebase-admin/app"; //importamos o firebase para o projeto
import { routes } from "./routes/index";

initializeApp(); //iniciamos o fire base para usarmos
const app = express(); 

routes(app); //

app.listen(3000, () => {
    console.log("servidor rodando");
});