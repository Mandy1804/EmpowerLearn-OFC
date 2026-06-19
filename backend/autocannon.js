const autocannon = require('autocannon');

const instance = autocannon({
    url: 'http://localhost:3000',
    connections: 100,
    duration: 10,
    requests: [
        {
            method: 'POST',
            path: '/auth/login',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                email: 'teste@empowerlearn.com',
                senha: 'senha123'
            })
        },
        {
            method: 'GET',
            path: '/cursos'
        },
        {
            method: 'GET',
            path: '/users'
        }
    ]
}, (err, result) => {
    if (err) {
        console.error('Erro:', err);
        return;
    }
    console.log('\n========== RELATÓRIO EMPOWERLEARN ==========');
    console.log(`Duração: ${result.duration}s`);
    console.log(`Total de requisições: ${result.requests.total}`);
    console.log(`Requisições/segundo: ${result.requests.average}`);
    console.log(`Latência média: ${result.latency.average}ms`);
    console.log(`Latência máxima: ${result.latency.max}ms`);
    console.log(`Throughput médio: ${result.throughput.average} bytes/s`);
    console.log(`Erros: ${result.errors}`);
    console.log(`Timeouts: ${result.timeouts}`);
    console.log('=============================================');
});

autocannon.track(instance, { renderProgressBar: true });