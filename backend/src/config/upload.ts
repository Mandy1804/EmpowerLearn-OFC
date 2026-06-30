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
      "image/pjpeg",
      "image/x-png",
      "application/octet-stream",
    ];

    const nomeArquivo = file.originalname.toLowerCase();

    const extensaoPermitida =
      nomeArquivo.endsWith(".jpg") ||
      nomeArquivo.endsWith(".jpeg") ||
      nomeArquivo.endsWith(".png") ||
      nomeArquivo.endsWith(".webp");

    const mimetypePermitido = tiposPermitidos.includes(file.mimetype);

    if (!mimetypePermitido && !extensaoPermitida) {
      return cb(new Error("Formato de imagem inválido"));
    }

    cb(null, true);
  },
});