<div align="center">

# 🎓 EmpowerLearn-OFC

### EmpowerLearn + EmpowerLearn.class  
**Plataforma educacional para conectar professores, alunos e instituições em um ecossistema digital moderno, seguro e responsivo.**

<br/>

![Status](https://img.shields.io/badge/status-validado-brightgreen?style=for-the-badge)
![Backend](https://img.shields.io/badge/backend-Node.js%20%2B%20TypeScript-339933?style=for-the-badge&logo=node.js&logoColor=white)
![Mobile](https://img.shields.io/badge/mobile-Flutter%20%2B%20Dart-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Database](https://img.shields.io/badge/database-PostgreSQL%20%2F%20Prisma-2D3748?style=for-the-badge&logo=prisma&logoColor=white)
![Realtime](https://img.shields.io/badge/realtime-Socket.IO-010101?style=for-the-badge&logo=socket.io&logoColor=white)

</div>

---

## 📌 Sobre o projeto

O **EmpowerLearn** é uma plataforma digital voltada ao setor educacional, criada para facilitar a conexão entre **professores, alunos e instituições de ensino**.

O projeto contempla dois grandes blocos:

| Módulo | Descrição |
|---|---|
| **EmpowerLearn API** | Backend REST para autenticação, cursos, matérias, tarefas, fórum, notificações, usuários, perfil e integrações. |
| **EmpowerLearn.class** | Aplicativo mobile desenvolvido em Flutter para acesso dos usuários ao ambiente educacional. |

A proposta é centralizar recursos educacionais em uma experiência integrada, com autenticação, controle de acesso, acompanhamento de atividades, fórum, notificações e suporte a comunicação em tempo real.

---

## ✨ Funcionalidades principais

### 👤 Usuários e autenticação
- Cadastro de usuários.
- Login com autenticação por token.
- Controle de perfis.
- Atualização de dados do usuário.
- Upload e exibição de foto de perfil.

### 📚 Cursos e matérias
- Listagem de cursos.
- Consulta de detalhes.
- Organização por matérias.
- Visualização de conteúdos educacionais.

### ✅ Tarefas e submissões
- Consulta de tarefas.
- Controle por tipo de usuário.
- Envio e acompanhamento de submissões.
- Regras de permissão para ações administrativas e acadêmicas.

### 💬 Fórum e comentários
- Publicação de posts.
- Comentários em tópicos.
- Interação entre usuários.
- Organização por curso/matéria.

### 🔔 Notificações e tempo real
- Consulta de notificações via API.
- Backend com suporte a **Socket.IO**.
- Teste funcional de conexão em tempo real validado em ambiente publicado.

### 📱 App mobile
- Interface responsiva em Flutter.
- Login e cadastro.
- Dashboard.
- Cursos, tarefas, fórum, notificações e perfil.
- Integração com API por variável de build `API_BASE_URL`.

---

## 🧱 Stack tecnológica

<div align="center">

### Backend
![Node.js](https://img.shields.io/badge/Node.js-339933?style=flat-square&logo=node.js&logoColor=white)
![TypeScript](https://img.shields.io/badge/TypeScript-3178C6?style=flat-square&logo=typescript&logoColor=white)
![Express](https://img.shields.io/badge/Express-000000?style=flat-square&logo=express&logoColor=white)
![Prisma](https://img.shields.io/badge/Prisma-2D3748?style=flat-square&logo=prisma&logoColor=white)
![Socket.IO](https://img.shields.io/badge/Socket.IO-010101?style=flat-square&logo=socket.io&logoColor=white)

### Mobile
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=flat-square&logo=dart&logoColor=white)

### Qualidade e testes
![Jest](https://img.shields.io/badge/Jest-C21325?style=flat-square&logo=jest&logoColor=white)
![Autocannon](https://img.shields.io/badge/Autocannon-Teste%20de%20Carga-orange?style=flat-square)
![Flutter Test](https://img.shields.io/badge/Flutter%20Test-aprovado-brightgreen?style=flat-square)

### Infraestrutura
![Railway](https://img.shields.io/badge/Railway-deploy-0B0D0E?style=flat-square&logo=railway&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-4169E1?style=flat-square&logo=postgresql&logoColor=white)
![AWS S3](https://img.shields.io/badge/AWS%20S3-arquivos-FF9900?style=flat-square&logo=amazonaws&logoColor=white)

</div>

---

## 🗂️ Estrutura do repositório

```txt
EmpowerLearn-OFC/
├── backend/                         # API Node.js + TypeScript + Prisma
│   ├── prisma/                      # Schema e migrations
│   ├── src/
│   │   ├── __tests__/               # Testes automatizados Jest/Supertest
│   │   ├── config/                  # Prisma, Socket.IO e upload
│   │   ├── controllers/             # Camada de entrada HTTP
│   │   ├── errors/                  # Tratamento padronizado de erros
│   │   ├── middlewares/             # Auth, permissões e erros
│   │   ├── repositories/            # Acesso a dados
│   │   ├── routes/                  # Rotas REST
│   │   ├── services/                # Regras de negócio
│   │   └── index.ts                 # Inicialização da API e Socket.IO
│   ├── autocannon.homologacao.js    # Teste de carga da API publicada
│   └── validar-socketio.js          # Teste funcional Socket.IO
│
├── flutter/                         # App mobile EmpowerLearn.class
│   ├── android/                     # Configuração Android
│   ├── lib/
│   │   ├── pages/                   # Login e cadastro
│   │   ├── screens/                 # Telas principais
│   │   ├── services/                # ApiService e integrações
│   │   ├── widgets/                 # Componentes reutilizáveis
│   │   └── main.dart                # Entrada do app
│   └── test/                        # Testes Flutter
│
├── docs/                            # Relatórios e documentação técnica
├── scripts/                         # Scripts de validação e build
├── docker-compose.yml
└── README.md
```

---

## 🔌 Principais endpoints da API

| Área | Endpoint | Descrição |
|---|---|---|
| Auth | `POST /auth/register` | Cadastro de usuário |
| Auth | `POST /auth/login` | Login e geração de token |
| Usuários | `GET /users/me` | Dados do usuário autenticado |
| Usuários | `PATCH /users/me` | Atualização do perfil |
| Usuários | `POST /users/me/foto` | Upload de foto |
| Cursos | `GET /cursos` | Listagem de cursos |
| Matérias | `GET /materias` | Consulta de matérias |
| Matrículas | `GET /matriculas` | Consulta de matrículas |
| Tarefas | `GET /tarefas` | Listagem de tarefas |
| Submissões | `GET /submissoes` | Consulta de submissões |
| Fórum | `GET /forum` | Posts do fórum |
| Comentários | `GET /comentarios` | Comentários de posts |
| Notificações | `GET /notificacoes` | Consulta de notificações |
| Vídeos | `GET /videos` | Conteúdos em vídeo |
| Progresso | `GET /progresso-materias` | Acompanhamento de progresso |
| Favoritos | `GET /favoritos` | Itens favoritados |
| Histórico | `GET /historico` | Histórico do usuário |

---

## ⚙️ Configuração do backend

### 1. Entrar na pasta

```bash
cd backend
```

### 2. Instalar dependências

```bash
npm install
```

### 3. Configurar variáveis de ambiente

Crie um arquivo `.env` com base no `.env.example`.

Variáveis principais:

```env
DATABASE_URL=
JWT_SECRET=
JWT_REFRESH_SECRET=
PORT=3000
```

> ⚠️ Nunca publique credenciais reais no GitHub.

### 4. Gerar Prisma Client

```bash
npx prisma generate
```

### 5. Executar em desenvolvimento

```bash
npm run dev
```

---

## 📱 Configuração do app mobile

### 1. Entrar na pasta

```bash
cd flutter
```

### 2. Instalar dependências

```bash
flutter pub get
```

### 3. Rodar análise estática

```bash
flutter analyze
```

### 4. Executar testes

```bash
flutter test
```

### 5. Gerar APK release

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://empowerlearn-ofc-production.up.railway.app
```

APK gerado em:

```txt
flutter/build/app/outputs/flutter-apk/app-release.apk
```

---

## 🧪 Validação e qualidade

O projeto possui scripts para facilitar a validação técnica.

### Validar app mobile

```bash
./scripts/validar_mobile_flutter_gitbash.sh
```

Valida:

- `flutter pub get`
- `flutter analyze`
- `flutter test`
- permissão Android de internet
- uso de `API_BASE_URL`

### Gerar APK

```bash
./scripts/gerar_apk_mobile_flutter_gitbash.sh
```

### Validar backend

```bash
BASE_URL="https://empowerlearn-ofc-production.up.railway.app" ./scripts/validar_backend_node_gitbash.sh
```

Valida:

- `npm install`
- `npm run build`
- `npm test`
- conexão Socket.IO
- teste de carga com Autocannon

---

## ✅ Resultados de validação

### Mobile

| Validação | Resultado |
|---|---|
| `flutter pub get` | ✅ Aprovado |
| `flutter analyze` | ✅ Sem issues |
| `flutter test` | ✅ Testes aprovados |
| Permissão `INTERNET` | ✅ Configurada |
| Build APK release | ✅ Gerado com sucesso |

### Backend

| Validação | Resultado |
|---|---|
| `npm install` | ✅ Concluído |
| `npm run build` | ✅ Compilação aprovada |
| `npm test` | ✅ 6 testes aprovados |
| Socket.IO | ✅ Conexão validada |
| Teste de carga | ✅ Sem erros de conexão e sem timeouts |

### Teste de carga observado

```txt
Total de requisições: 4692
Requisições/segundo: 234.6
Latência média: 212.45ms
Latência máxima: 531ms
Erros de conexão: 0
Timeouts: 0
```

---

## 📄 Documentação técnica

Os principais documentos de validação estão em `docs/`:

| Documento | Finalidade |
|---|---|
| `DOCUMENTACAO_MOBILE_EMPOWERLEARN_CLASS.md` | Documentação do app mobile |
| `RELATORIO_VALIDACAO_MOBILE_APK.md` | Relatório de validação do APK |
| `RELATORIO_VALIDACAO_BACKEND_NODE.md` | Validação técnica do backend |
| `RELATORIO_TESTE_CARGA_API_NODE.md` | Evidência de teste de carga |
| `ANALISE_WEBSOCKET_E_NOTIFICACOES.md` | Análise Socket.IO/WebSocket |

---

## 🔐 Segurança e observações

- O app mobile não armazena credenciais sensíveis.
- A URL da API é definida via `API_BASE_URL` no build.
- O backend exige variáveis de ambiente para banco e autenticação.
- O arquivo `.env` não deve ser versionado.
- O APK depende da API publicada para funcionamento completo.
- Em redes institucionais restritivas, o acesso ao backend publicado pode depender de liberação da rede. Em rede móvel 4G/5G, o app tende a funcionar normalmente se a API estiver online.

---

## 🚀 Deploy

O backend está preparado para execução em ambiente publicado, com configuração por variáveis de ambiente.

Checklist de deploy:

```txt
DATABASE_URL
JWT_SECRET
JWT_REFRESH_SECRET
PORT
Configurações de CORS
Configurações de upload/S3, quando aplicável
```

Após o deploy, validar:

```bash
BASE_URL="URL_PUBLICADA" ./scripts/validar_backend_node_gitbash.sh
```

---

## 👥 Time

| Integrante | Participação |
|---|---|
| Victor Suzuki | Desenvolvimento, integração mobile/API, validação técnica e documentação |
| Amanda | Deploy e suporte ao fluxo de publicação |
| Equipe EmpowerLearn | Desenvolvimento e validação geral do projeto |

---

## 🏁 Status final

```txt
Backend REST: aprovado
Mobile Flutter: aprovado
Testes automatizados: aprovados
Socket.IO/WebSocket: aprovado
Teste de carga: aprovado sem erros de conexão/timeouts
Documentação técnica: criada
APK release: gerado
```

---

<div align="center">

### EmpowerLearn.class  
**Conectando educação, tecnologia e pessoas.**

</div>
