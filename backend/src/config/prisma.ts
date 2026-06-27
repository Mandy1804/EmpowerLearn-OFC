import { PrismaClient } from "../generated/prisma/client";
import { PrismaPg } from "@prisma/adapter-pg";
import { Pool } from "pg";

const connectionString = process.env.DATABASE_URL;

if (!connectionString) {
    throw new Error("DATABASE_URL não configurada.");
}

const usarSslSemValidarCertificado =
    process.env.NODE_ENV === "production" ||
    process.env.NODE_TLS_REJECT_UNAUTHORIZED === "0" ||
    connectionString.includes("sslmode=");

const pool = new Pool({
    connectionString,
    ssl: usarSslSemValidarCertificado
        ? { rejectUnauthorized: false }
        : undefined,
});

const adapter = new PrismaPg(pool);

const prisma = new PrismaClient({
    adapter,
});

export default prisma;
