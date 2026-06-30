#!/usr/bin/env bash
set -e

cd "$(dirname "$0")/.."

if [ ! -d "backend" ]; then
  echo "ERRO: pasta backend/ nao encontrada. Rode este script na raiz do repositorio."
  exit 1
fi

cd backend

BASE_URL="${BASE_URL:-https://empowerlearn-ofc-production.up.railway.app}"
CONNECTIONS="${CONNECTIONS:-50}"
DURATION="${DURATION:-20}"

echo "=== npm install ==="
npm install

echo ""
echo "=== npm run build ==="
npm run build

echo ""
echo "=== npm test ==="
npm test

echo ""
echo "=== Teste Socket.IO homologacao ==="
BASE_URL="$BASE_URL" node validar-socketio.js

echo ""
echo "=== Teste carga API homologacao ==="
BASE_URL="$BASE_URL" CONNECTIONS="$CONNECTIONS" DURATION="$DURATION" node autocannon.homologacao.js

echo ""
echo "Validacao backend Node concluida."
