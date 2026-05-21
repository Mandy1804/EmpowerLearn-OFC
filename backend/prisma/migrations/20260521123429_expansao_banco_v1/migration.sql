/*
  Warnings:

  - You are about to drop the column `video_url` on the `materias` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "cursos" ADD COLUMN     "categoria_id" INTEGER;

-- AlterTable
ALTER TABLE "materias" DROP COLUMN "video_url";

-- CreateTable
CREATE TABLE "categorias" (
    "id" SERIAL NOT NULL,
    "nome" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "categorias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "videos" (
    "id" SERIAL NOT NULL,
    "materia_id" INTEGER NOT NULL,
    "titulo" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "ordem" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "videos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "historico" (
    "id" SERIAL NOT NULL,
    "aluno_id" INTEGER NOT NULL,
    "materia_id" INTEGER NOT NULL,
    "data_acesso" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "historico_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "favoritos" (
    "id" SERIAL NOT NULL,
    "aluno_id" INTEGER NOT NULL,
    "tipo" TEXT NOT NULL,
    "ref_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "favoritos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notas_aluno" (
    "id" SERIAL NOT NULL,
    "aluno_id" INTEGER NOT NULL,
    "materia_id" INTEGER NOT NULL,
    "titulo" TEXT NOT NULL,
    "conteudo" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notas_aluno_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_tokens" (
    "id" SERIAL NOT NULL,
    "token" TEXT NOT NULL,
    "usuario_id" INTEGER NOT NULL,
    "expira_em" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "refresh_tokens_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "categorias_nome_key" ON "categorias"("nome");

-- CreateIndex
CREATE UNIQUE INDEX "favoritos_aluno_id_tipo_ref_id_key" ON "favoritos"("aluno_id", "tipo", "ref_id");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_tokens_token_key" ON "refresh_tokens"("token");

-- AddForeignKey
ALTER TABLE "cursos" ADD CONSTRAINT "cursos_categoria_id_fkey" FOREIGN KEY ("categoria_id") REFERENCES "categorias"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "videos" ADD CONSTRAINT "videos_materia_id_fkey" FOREIGN KEY ("materia_id") REFERENCES "materias"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "historico" ADD CONSTRAINT "historico_aluno_id_fkey" FOREIGN KEY ("aluno_id") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "historico" ADD CONSTRAINT "historico_materia_id_fkey" FOREIGN KEY ("materia_id") REFERENCES "materias"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "favoritos" ADD CONSTRAINT "favoritos_aluno_id_fkey" FOREIGN KEY ("aluno_id") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notas_aluno" ADD CONSTRAINT "notas_aluno_aluno_id_fkey" FOREIGN KEY ("aluno_id") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notas_aluno" ADD CONSTRAINT "notas_aluno_materia_id_fkey" FOREIGN KEY ("materia_id") REFERENCES "materias"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "refresh_tokens" ADD CONSTRAINT "refresh_tokens_usuario_id_fkey" FOREIGN KEY ("usuario_id") REFERENCES "usuarios"("id") ON DELETE CASCADE ON UPDATE CASCADE;
