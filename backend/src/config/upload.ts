import fs from "fs";
import path from "path";
import multer from "multer";

const uploadDir = path.resolve(process.cwd(), "uploads", "perfil");

if (!fs.existsSync(uploadDir)) {
    fs.mkdirSync(uploadDir, { recursive: true });
}

function definirExtensao(file: Express.Multer.File): string {
    const extOriginal = path.extname(file.originalname || "").toLowerCase();

    if ([".jpg", ".jpeg", ".png", ".webp", ".gif"].includes(extOriginal)) {
        return extOriginal;
    }

    if (file.mimetype === "image/png") return ".png";
    if (file.mimetype === "image/webp") return ".webp";
    if (file.mimetype === "image/gif") return ".gif";

    return ".jpg";
}

const storage = multer.diskStorage({
    destination: (_req, _file, cb) => {
        cb(null, uploadDir);
    },
    filename: (_req, file, cb) => {
        const ext = definirExtensao(file);
        const nome = `perfil_${Date.now()}_${Math.round(Math.random() * 1e9)}${ext}`;
        cb(null, nome);
    },
});

export const uploadPerfil = multer({
    storage,
    limits: {
        fileSize: 5 * 1024 * 1024,
    },
    fileFilter: (_req, file, cb) => {
        const mimetype = file.mimetype || "";
        const ext = path.extname(file.originalname || "").toLowerCase();

        const pareceImagem =
            mimetype.startsWith("image/") ||
            mimetype === "application/octet-stream" ||
            [".jpg", ".jpeg", ".png", ".webp", ".gif"].includes(ext);

        if (!pareceImagem) {
            cb(new Error("Arquivo enviado não parece ser uma imagem."));
            return;
        }

        cb(null, true);
    },
});
