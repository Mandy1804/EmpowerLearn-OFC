const { io } = require('socket.io-client');

const baseUrl = process.env.BASE_URL || 'https://empowerlearn-ofc-production.up.railway.app';

console.log('========== TESTE WEBSOCKET / SOCKET.IO ==========');
console.log(`Conectando em: ${baseUrl}`);

const socket = io(baseUrl, {
  transports: ['websocket', 'polling'],
  timeout: 10000,
  reconnection: false,
});

const timer = setTimeout(() => {
  console.error('Falha: tempo limite ao tentar conectar no Socket.IO.');
  socket.disconnect();
  process.exit(1);
}, 15000);

socket.on('connect', () => {
  clearTimeout(timer);
  console.log(`Socket.IO conectado com sucesso. ID: ${socket.id}`);
  socket.disconnect();
  console.log('Teste WebSocket/Socket.IO aprovado.');
  process.exit(0);
});

socket.on('connect_error', (err) => {
  clearTimeout(timer);
  console.error('Erro ao conectar no Socket.IO:', err.message);
  socket.disconnect();
  process.exit(1);
});
