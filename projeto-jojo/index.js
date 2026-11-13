// API do catálogo JoJo: serve o site e faz o CRUD das cinco entidades no MySQL.
require('dotenv').config();

const path = require('path');
const express = require('express');
const mysql = require('mysql2/promise');

const app = express();

app.use(express.json());
app.use(express.static(path.join(__dirname, 'site')));

const pool = mysql.createPool({
    host: process.env.MYSQL_HOST || 'localhost',
    port: Number(process.env.MYSQL_PORT) || 3306,
    user: process.env.MYSQL_USER || 'root',
    password: process.env.MYSQL_PASSWORD || '',
    database: process.env.MYSQL_DATABASE || 'jojo_db',
    waitForConnections: true,
    connectionLimit: 10
});

const ENTIDADES = {
    parte_obra: {
        tabela: 'parte_obra',
        pk: 'id_parte',
        campos: ['numero_parte', 'nome_arco'],
        obrigatorios: ['numero_parte', 'nome_arco'],
        numericos: []
    },
    personagem: {
        tabela: 'personagem',
        pk: 'id_personagem',
        campos: ['nome', 'descricao', 'id_parte'],
        obrigatorios: ['nome', 'descricao', 'id_parte'],
        numericos: ['id_parte']
    },
    stand: {
        tabela: 'stand',
        pk: 'id_stand',
        campos: ['nome_stand', 'habilidade', 'id_personagem'],
        obrigatorios: ['nome_stand', 'habilidade', 'id_personagem'],
        numericos: ['id_personagem']
    },
    galeria_imagem: {
        tabela: 'galeria_imagem',
        pk: 'id_imagem',
        campos: ['url_imagem', 'desc_imagem', 'id_personagem'],
        obrigatorios: ['url_imagem', 'desc_imagem', 'id_personagem'],
        numericos: ['id_personagem']
    },
    encontro_batalha: {
        tabela: 'encontro_batalha',
        pk: 'id_batalha',
        campos: ['local_confronto', 'desfecho', 'id_personagem'],
        obrigatorios: ['local_confronto', 'desfecho', 'id_personagem'],
        numericos: ['id_personagem']
    }
};

function tratarErro(res, erro, acao) {
    console.error(`Erro ao ${acao}:`, erro.code || erro.message);

    if (erro.code === 'ER_DUP_ENTRY') {
        return res.status(409).json({
            status: 'erro',
            mensagem: 'Já existe um registro com esse valor único (parte repetida ou personagem que já possui stand).'
        });
    }
    if (erro.code === 'ER_NO_REFERENCED_ROW_2') {
        return res.status(400).json({ status: 'erro', mensagem: 'O registro relacionado informado não existe.' });
    }
    if (erro.code === 'ER_ROW_IS_REFERENCED_2') {
        return res.status(409).json({ status: 'erro', mensagem: 'Este registro possui dependências e não pode ser excluído.' });
    }
    return res.status(500).json({ status: 'erro', mensagem: `Não foi possível ${acao}.` });
}

app.get('/api/opcoes', async (req, res) => {
    try {
        const [partes] = await pool.query(
            'SELECT id_parte AS id, CONCAT(numero_parte, " - ", nome_arco) AS rotulo FROM parte_obra ORDER BY id_parte'
        );
        const [personagens] = await pool.query(
            'SELECT id_personagem AS id, nome AS rotulo FROM personagem ORDER BY nome'
        );
        res.json({ parte_obra: partes, personagem: personagens });
    } catch (erro) {
        tratarErro(res, erro, 'carregar as opções');
    }
});

// Página inicial: personagem com parte, stand e primeira imagem.
app.get('/api/home', async (req, res) => {
    try {
        const [linhas] = await pool.query(`
            SELECT p.id_personagem, p.nome, p.descricao,
                   po.numero_parte, po.nome_arco,
                   s.nome_stand,
                   (SELECT gi.url_imagem FROM galeria_imagem gi
                     WHERE gi.id_personagem = p.id_personagem
                     ORDER BY gi.id_imagem LIMIT 1) AS imagem,
                   (SELECT gi.desc_imagem FROM galeria_imagem gi
                     WHERE gi.id_personagem = p.id_personagem
                     ORDER BY gi.id_imagem LIMIT 1) AS desc_imagem
              FROM personagem p
              JOIN parte_obra po ON po.id_parte = p.id_parte
              LEFT JOIN stand s ON s.id_personagem = p.id_personagem
             ORDER BY po.id_parte, p.nome
        `);
        res.json(linhas);
    } catch (erro) {
        tratarErro(res, erro, 'carregar a página inicial');
    }
});

// CRUD genérico: as rotas abaixo atendem as cinco entidades.
app.get('/api/:entidade', async (req, res) => {
    const meta = ENTIDADES[req.params.entidade];
    if (!meta) return res.status(404).json({ status: 'erro', mensagem: 'Entidade inexistente.' });

    try {
        const [linhas] = await pool.query(`SELECT * FROM ${meta.tabela} ORDER BY ${meta.pk}`);
        res.json(linhas);
    } catch (erro) {
        tratarErro(res, erro, 'listar os registros');
    }
});

app.get('/api/:entidade/:id', async (req, res) => {
    const meta = ENTIDADES[req.params.entidade];
    if (!meta) return res.status(404).json({ status: 'erro', mensagem: 'Entidade inexistente.' });

    try {
        const [linhas] = await pool.query(`SELECT * FROM ${meta.tabela} WHERE ${meta.pk} = ?`, [req.params.id]);
        if (linhas.length === 0) return res.status(404).json({ status: 'erro', mensagem: 'Registro não encontrado.' });
        res.json(linhas[0]);
    } catch (erro) {
        tratarErro(res, erro, 'consultar o registro');
    }
});

app.post('/api/:entidade', async (req, res) => {
    const meta = ENTIDADES[req.params.entidade];
    if (!meta) return res.status(404).json({ status: 'erro', mensagem: 'Entidade inexistente.' });

    const corpo = req.body || {};
    const faltando = meta.obrigatorios.filter((campo) => String(corpo[campo] ?? '').trim() === '');
    if (faltando.length > 0) {
        return res.status(400).json({ status: 'erro', mensagem: `Preencha os campos obrigatórios: ${faltando.join(', ')}.` });
    }

    const valores = meta.campos.map((campo) => {
        const valor = String(corpo[campo] ?? '').trim();
        return meta.numericos.includes(campo) ? Number(valor) : valor;
    });

    try {
        const sql = `INSERT INTO ${meta.tabela} (${meta.campos.join(', ')}) VALUES (${meta.campos.map(() => '?').join(', ')})`;
        const [resultado] = await pool.query(sql, valores);
        res.status(201).json({ status: 'sucesso', id: resultado.insertId });
    } catch (erro) {
        tratarErro(res, erro, 'salvar o registro');
    }
});

app.put('/api/:entidade/:id', async (req, res) => {
    const meta = ENTIDADES[req.params.entidade];
    if (!meta) return res.status(404).json({ status: 'erro', mensagem: 'Entidade inexistente.' });

    const corpo = req.body || {};
    const faltando = meta.obrigatorios.filter((campo) => String(corpo[campo] ?? '').trim() === '');
    if (faltando.length > 0) {
        return res.status(400).json({ status: 'erro', mensagem: `Preencha os campos obrigatórios: ${faltando.join(', ')}.` });
    }

    const valores = meta.campos.map((campo) => {
        const valor = String(corpo[campo] ?? '').trim();
        return meta.numericos.includes(campo) ? Number(valor) : valor;
    });

    try {
        const sql = `UPDATE ${meta.tabela} SET ${meta.campos.map((campo) => `${campo} = ?`).join(', ')} WHERE ${meta.pk} = ?`;
        const [resultado] = await pool.query(sql, [...valores, req.params.id]);
        if (resultado.affectedRows === 0) return res.status(404).json({ status: 'erro', mensagem: 'Registro não encontrado.' });
        res.json({ status: 'sucesso' });
    } catch (erro) {
        tratarErro(res, erro, 'atualizar o registro');
    }
});

app.delete('/api/:entidade/:id', async (req, res) => {
    const meta = ENTIDADES[req.params.entidade];
    if (!meta) return res.status(404).json({ status: 'erro', mensagem: 'Entidade inexistente.' });

    try {
        const [resultado] = await pool.query(`DELETE FROM ${meta.tabela} WHERE ${meta.pk} = ?`, [req.params.id]);
        if (resultado.affectedRows === 0) return res.status(404).json({ status: 'erro', mensagem: 'Registro não encontrado.' });
        res.json({ status: 'sucesso' });
    } catch (erro) {
        tratarErro(res, erro, 'excluir o registro');
    }
});

if (require.main === module) {
    const porta = Number(process.env.PORT) || 3000;
    app.listen(porta, () => {
        console.log(`Servidor executando em http://localhost:${porta}`);
        pool.query('SELECT 1')
            .then(() => console.log(`Conectado ao MySQL (banco ${process.env.MYSQL_DATABASE || 'jojo_db'})`))
            .catch((erro) => console.error('Falha ao conectar no MySQL:', erro.message));
    });
}

module.exports = app;
