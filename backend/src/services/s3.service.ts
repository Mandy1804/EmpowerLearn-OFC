import { PutObjectCommand, S3Client } from "@aws-sdk/client-s3";
import crypto from "crypto";

const region = process.env.AWS_REGION;
const bucket = process.env.AWS_S3_BUCKET;
const publicUrl = process.env.AWS_S3_PUBLIC_URL;

const s3 = new S3Client({
  region,
  credentials:
    process.env.AWS_ACCESS_KEY_ID && process.env.AWS_SECRET_ACCESS_KEY
      ? {
          accessKeyId: process.env.AWS_ACCESS_KEY_ID,
          secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
        }
      : undefined,
});

function gerarNomeArquivo(originalName: string) {
  const extensao = originalName.includes(".")
    ? originalName.substring(originalName.lastIndexOf(".")).toLowerCase()
    : "";

  const nomeSeguro = crypto.randomBytes(16).toString("hex");

  return `${nomeSeguro}${extensao}`;
}

export async function uploadArquivoS3(params: {
  file: Express.Multer.File;
  pasta: string;
}) {
  if (!region) {
    throw new Error("AWS_REGION não configurada");
  }

  if (!bucket) {
    throw new Error("AWS_S3_BUCKET não configurado");
  }

  const nomeArquivo = gerarNomeArquivo(params.file.originalname);
  const key = `${params.pasta}/${nomeArquivo}`;

  await s3.send(
    new PutObjectCommand({
      Bucket: bucket,
      Key: key,
      Body: params.file.buffer,
      ContentType: params.file.mimetype,
    })
  );

  if (publicUrl) {
    return `${publicUrl.replace(/\/$/, "")}/${key}`;
  }

  return `https://${bucket}.s3.${region}.amazonaws.com/${key}`;
}