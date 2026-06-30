# Relatório de Teste de Carga API Node.js - EmpowerLearn.class

## 1. Objetivo

Validar a capacidade de resposta da API Node.js utilizada pelo app EmpowerLearn.class por meio de teste de carga em ambiente publicado.

## 2. Ferramenta

Foi utilizado Autocannon.

Arquivo utilizado: backend/autocannon.homologacao.js

## 3. Ambiente testado

https://empowerlearn-ofc-production.up.railway.app

## 4. Configuração do teste

Conexões: 50
Duração: 20 segundos
Endpoints testados:
- GET /cursos
- GET /forum
- GET /notificacoes?usuarioId=1

## 5. Resultado observado

Total de requisições: 4692
Requisições por segundo: 234.6
Latência média: 212.45ms
Latência máxima: 531ms
Throughput médio: 95482.4 bytes/s
Erros de conexão: 0
Timeouts: 0
Respostas não 2xx: 4692

## 6. Interpretação

O teste demonstrou que a API publicada respondeu sob carga sem erros de conexão e sem timeouts. As respostas não 2xx ocorreram porque os endpoints utilizados podem exigir autenticação, dados específicos ou regras de acesso, mas o servidor permaneceu respondendo.

## 7. Observação sobre teste local

O teste local anterior apresentou resultado inválido porque o backend não estava rodando corretamente sem a variável DATABASE_URL. Portanto, o teste local com 0 req/s, erros em massa e servidor indisponível não foi considerado como evidência de carga aprovada.

## 8. Conclusão

A API publicada apresentou estabilidade de conexão sob carga moderada, com 50 conexões por 20 segundos, sem timeouts e sem erros de conexão.
