"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const app_1 = require("firebase-admin/app"); //importamos o firebase para o projeto
const index_1 = require("./routes/index");
(0, app_1.initializeApp)(); //iniciamos o fire base para usarmos
const app = (0, express_1.default)();
(0, index_1.routes)(app); //
app.listen(3000, () => {
    console.log("servidor rodando");
});
//# sourceMappingURL=index.js.map