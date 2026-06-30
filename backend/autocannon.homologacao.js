const autocannon = require('autocannon');

const baseUrl = process.env.BASE_URL || 'https://empowerlearn-ofc-production.up.railway.app';
const connections = Number(process.env.CONNECTIONS || 50);
const duration = Number(process.env.DURATION || 20);

console.log('========== TESTE DE CARGA API NODE ==========');
console.log(`Base URL: ${baseUrl}`);
console.log(`Conexões: ${connections}`);
console.log(`Duração: ${duration}s`);

const instance = autocannon({
  url: baseUrl,
  connections,
  duration,
  timeout: 10,
  requests: [
    { method: 'GET', path: '/cursos' },
    { method: 'GET', path: '/forum' },
    { method: 'GET', path: '/notificacoes?usuarioId=1' },
  ],
}, (err, result) => {
  if (err) {
    console.error('Erro no Autocannon:', err);
    process.exitCode = 1;
    return;
  }

  console.log('\n========== RELATÓRIO EMPOWERLEARN API NODE ==========');
  console.log(`Duração: ${result.duration}s`);
  console.log(`Total de requisições: ${result.requests.total}`);
  console.log(`Requisições/segundo: ${result.requests.average}`);
  console.log(`Latência média: ${result.latency.average}ms`);
  console.log(`Latência máxima: ${result.latency.max}ms`);
  console.log(`Throughput médio: ${result.throughput.average} bytes/s`);
  console.log(`Erros de conexão: ${result.errors}`);
  console.log(`Timeouts: ${result.timeouts}`);
  console.log(`Respostas não 2xx: ${result.non2xx || 0}`);
  console.log('======================================================');

  if (result.errors > 0 || result.timeouts > 0) {
    process.exitCode = 1;
  }
});

autocannon.track(instance, { renderProgressBar: true });
