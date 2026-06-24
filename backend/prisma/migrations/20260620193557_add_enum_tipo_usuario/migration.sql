/*
  Migration para converter o campo usuarios.tipo de String para enum TipoUsuario.

  A versão anterior removia a coluna tipo e criava novamente.
  Isso poderia apagar dados ou falhar em bancos que já possuem usuários.

  Esta versão mantém a coluna existente e apenas converte o tipo dela.
*/

CREATE TYPE "TipoUsuario" AS ENUM ('aluno', 'professor', 'admin');

UPDATE "usuarios"
SET "tipo" = 'aluno'
WHERE "tipo" IN ('user', 'usuario', 'usuarios');

UPDATE "usuarios"
SET "tipo" = 'professor'
WHERE "tipo" IN ('professores');

UPDATE "usuarios"
SET "tipo" = 'admin'
WHERE "tipo" IN ('adm', 'administrador');

UPDATE "usuarios"
SET "tipo" = 'aluno'
WHERE "tipo" IS NULL;

ALTER TABLE "usuarios"
ALTER COLUMN "tipo" TYPE "TipoUsuario"
USING ("tipo"::"TipoUsuario");

ALTER TABLE "usuarios"
ALTER COLUMN "tipo" SET NOT NULL;
