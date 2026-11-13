# Catálogo JoJo - CRUD completo (Node.js + Express + MySQL)

Projeto da Lista de Exercícios de Banco de Dados (4º Bimestre).
A versão anterior tinha **uma** tela de cadastro e **uma** tabela (`obras`).
Agora cada entidade principal tem sua própria tela com CRUD completo.

## Entidades e telas

| Entidade | Tela | Campos do formulário |
| --- | --- | --- |
| `parte_obra` | `cadastro-parte-obra.html` | numero_parte, nome_arco |
| `personagem` | `cadastro-personagem.html` | nome, descricao, id_parte |
| `stand` | `cadastro-stand.html` | nome_stand, habilidade, id_personagem |
| `galeria_imagem` | `cadastro-galeria-imagem.html` | url_imagem, desc_imagem, id_personagem |
| `encontro_batalha` | `cadastro-encontro-batalha.html` | local_confronto, desfecho, id_personagem |

A página inicial (`site/index.html`) lista os personagens com parte, stand e imagem.

## Como executar

1. Importe o banco (recria as tabelas do `jojo_db`):

   ```bash
   mysql -u root -p < banco.sql
   ```

2. Copie `.env.example` para `.env` e informe a senha do MySQL.

3. Instale as dependências e inicie:

   ```bash
   npm install
   npm start
   ```

4. Abra http://localhost:3000

## API

| Método | Rota | Ação |
| --- | --- | --- |
| GET | `/api/home` | personagens com parte, stand e imagem |
| GET | `/api/opcoes` | listas para os campos de seleção |
| GET | `/api/:entidade` | listar registros |
| GET | `/api/:entidade/:id` | consultar um registro |
| POST | `/api/:entidade` | cadastrar |
| PUT | `/api/:entidade/:id` | editar |
| DELETE | `/api/:entidade/:id` | excluir |

Entidades aceitas: `parte_obra`, `personagem`, `stand`, `galeria_imagem`, `encontro_batalha`.

## Validações

- Campos obrigatórios são checados no navegador e no servidor.
- Chaves estrangeiras inexistentes retornam erro 400.
- Valor único repetido (parte repetida ou personagem que já tem stand) retorna erro 409.
- A exclusão de um personagem remove em cascata seu stand, imagens e batalhas (`ON DELETE CASCADE`).

## Revisão de atributos (item 2)

- `personagem.titulo` foi renomeado para `personagem.nome`.
- `parte_obra.numero_parte` recebeu restrição `UNIQUE`.
- `stand.id_personagem` recebeu restrição `UNIQUE` (relação 1:1).
- `descricao`, `habilidade`, `desfecho`, `url_imagem` e `desc_imagem` passaram a ser `NOT NULL`.
- A tabela `obras` foi removida: misturava dados de personagem e de imagem.
