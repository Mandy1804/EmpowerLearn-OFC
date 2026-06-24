import express from "express";
import { createServer } from "http";
import { Server } from "socket.io";
import { routes } from "./routes/index";
import { errorHandler } from "./middlewares/error-handler.middleware";
import { pageNotFoundHandler } from "./middlewares/page-not-found.middleware";
import { setSocketServer } from "./config/socket";
import cors from "cors";

const app = express();

app.use(cors({ origin: "*" }));

const httpServer = createServer(app);

export const io = new Server(httpServer, {
    cors: {
        origin: "*",
        methods: ["GET", "POST"]
    }
});

setSocketServer(io);

io.on("connection", (socket) => {
    console.log(`Cliente conectado: ${socket.id}`);

    socket.on("registrar", (usuarioId: number) => {
        socket.join(`usuario_${usuarioId}`);
        console.log(`Usuário ${usuarioId} registrado na sala usuario_${usuarioId}`);
    });

    socket.on("disconnect", () => {
        console.log(`Cliente desconectado: ${socket.id}`);
    });
});

routes(app);
pageNotFoundHandler(app);
errorHandler(app);

const PORT = process.env.PORT || 3000;

if (process.env.NODE_ENV !== "test") {
    httpServer.listen(PORT, () => {
        console.log(`Servidor rodando em http://localhost:${PORT}`);
    });
}

export { app, httpServer };
