# Sistemas Web / Banco de Dados

Repositório com as atividades de Sistemas Web e o projeto JoJo (Node + Express + MySQL).

## Estrutura

```
.
├── index.html, form.html, style.css, script.js, index.js   # atividade simples de Sistemas Web
├── package.json
└── projeto-jojo/                                           # projeto completo com banco de dados
    ├── site/                     # telas (home + 5 CRUDs)
    ├── index.js                  # servidor Express + API
    ├── banco.sql                 # cria o jojo_db, as tabelas e os dados
    ├── banco_jojo_completo.sql   # script único: banco + povoamento
    ├── povoamento_le5.sql        # só os INSERTs (15+ por tabela)
    ├── .env.example              # modelo de configuração do MySQL
    ├── iniciar.bat               # sobe o servidor no Windows
    └── README.md                 # detalhes do projeto
```

## Rodar o projeto com banco

Pré-requisitos: Node.js e MySQL 8 instalados.

```bash
cd projeto-jojo
mysql -u root -p --default-character-set=utf8mb4 < banco_jojo_completo.sql
cp .env.example .env      # no Windows: copy .env.example .env
# edite o .env e coloque a senha do seu MySQL
npm install
npm start
```

Abra `http://localhost:3000`.

O `.env` não vai para o repositório (está no `.gitignore`) — cada máquina usa o seu.

## Atividade simples de Sistemas Web

```bash
npm install
node index.js
```

Abre em `http://localhost:3000`.
