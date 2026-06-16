import express from "express";
import { initializeApp } from "firebase-admin/app"; //importamos o firebase para o projeto
import { routes } from "./routes/index";
import { errorHandler } from "./middlewares/error-handler.middleware";
import { pageNotFoundHandler } from "./middlewares/page-not-found.middleware";

initializeApp(); //iniciamos o fire base para usarmos
const app = express();
app.use(express.json());

routes(app); //
pageNotFoundHandler(app);
errorHandler(app);

app.listen(3000, () => {
    console.log("servidor rodando");
});