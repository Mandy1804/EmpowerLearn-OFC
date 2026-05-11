"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.userRoutes = void 0;
const express_1 = __importDefault(require("express"));
const users_controller_1 = require("../controller/users.controller");
exports.userRoutes = express_1.default.Router(); //um middleware para organizar as rotas de usuario
exports.userRoutes.get("/users", users_controller_1.UsersController.getAll);
exports.userRoutes.get("/users/:id", users_controller_1.UsersController.getById);
exports.userRoutes.post("/users", users_controller_1.UsersController.save);
exports.userRoutes.put("/users/:id", users_controller_1.UsersController.update);
exports.userRoutes.delete("/users/:id", users_controller_1.UsersController.delete);
//# sourceMappingURL=users.route.js.map