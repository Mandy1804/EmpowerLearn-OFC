"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = __importDefault(require("express"));
const app = (0, express_1.default)();
app.get("/", (req, res) => {
    res.send("Comeco da empower");
});
app.get("/users", (req, res) => {
    let usuarios = [{
            nome: "Victor Cellos",
            idade: 19
        }, {
            nome: "Eduardo Suzuki",
            idade: 25
        }];
    res.send(usuarios);
});
app.listen(3000, () => {
    console.log("servidor rodando");
});
//# sourceMappingURL=index.js.map