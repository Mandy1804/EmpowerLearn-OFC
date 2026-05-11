"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.routes = void 0;
const express_1 = __importDefault(require("express"));
const users_route_1 = require("./users.route");
const routes = (app) => {
    app.use(express_1.default.json()); //o app usa o express.json para formato de comuniçação 
    app.use(users_route_1.userRoutes); //aqui dizemos que o userroutes é quem vai gerenciar as rotas dos usuario
};
exports.routes = routes;
//# sourceMappingURL=index.js.map