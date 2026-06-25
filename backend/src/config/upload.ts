import multer from "multer";

const storage = multer.memoryStorage();

export const uploadPerfil = multer({
  storage,
  limits: {
    fileSize: 5 * 1024 * 1024,
  },
  fileFilter: (_req, file, cb) => {
    const tiposPermitidos = [
      "image/jpeg",
      "image/jpg",
      "image/png",
      "image/webp",
    ];

    if (!tiposPermitidos.includes(file.mimetype)) {
      return cb(new Error("Formato de imagem inválido"));
    }

    cb(null, true);
  },
});