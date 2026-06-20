/*
  Warnings:

  - Changed the type of `tipo` on the `usuarios` table. No cast exists, the column would be dropped and recreated, which cannot be done if there is data, since the column is required.

*/
-- CreateEnum
CREATE TYPE "TipoUsuario" AS ENUM ('aluno', 'professor', 'admin');

-- AlterTable
ALTER TABLE "usuarios" DROP COLUMN "tipo",
ADD COLUMN     "tipo" "TipoUsuario" NOT NULL;
