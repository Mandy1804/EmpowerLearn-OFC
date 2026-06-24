import express from "express";
import path from "path";
import { createServer } from "http";
import { Server } from "socket.io";
import cors from "cors";

import { routes } from "./routes/index";
import { errorHandler } from "./middlewares/error-handler.middleware";
import { pageNotFoundHandler } from "./middlewares/page-not-found.middleware";
import { setSocketServer } from "./config/socket";

const app = express();

app.set("trust proxy", 1);

app.use(
    cors({
        origin: "*",
        methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
        allowedHeaders: [
            "Origin",
            "X-Requested-With",
            "Content-Type",
            "Accept",
            "Authorization",
        ],
    })
);


app.use(
    "/uploads",
    express.static(path.resolve(process.cwd(), "uploads"), {
        setHeaders: (res) => {
            res.setHeader("Access-Control-Allow-Origin", "*");
            res.setHeader(
                "Access-Control-Allow-Methods",
                "GET, OPTIONS"
            );
            res.setHeader(
                "Access-Control-Allow-Headers",
                "Origin, X-Requested-With, Content-Type, Accept, Authorization"
            );
            res.setHeader("Cross-Origin-Resource-Policy", "cross-origin");
            res.setHeader("Cache-Control", "no-store");
        },
    })
);

const httpServer = createServer(app);

export const io = new Server(httpServer, {
    cors: {
        origin: "*",
        methods: ["GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"],
    },
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
