import { Server } from "socket.io";

let socketServer: Server | null = null;

export function setSocketServer(server: Server) {
    socketServer = server;
}

export function emitToUser(usuarioId: number, eventName: string, payload: unknown) {
    if (!socketServer) {
        return;
    }

    socketServer.to(`usuario_${usuarioId}`).emit(eventName, payload);
}
