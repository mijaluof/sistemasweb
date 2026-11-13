// Monta o formulário, a tabela e as ações de CRUD de cada tela de cadastro.
const ESQUEMAS = {
    'parte-obra': {
        entidade: 'parte_obra',
        titulo: 'Parte da obra',
        pk: 'id_parte',
        rotuloPk: 'Código',
        campos: [
            { nome: 'numero_parte', rotulo: 'Número da parte', tipo: 'text', obrigatorio: true, exemplo: 'Parte 6' },
            { nome: 'nome_arco', rotulo: 'Nome do arco', tipo: 'text', obrigatorio: true, exemplo: 'Stone Ocean' }
        ]
    },
    personagem: {
        entidade: 'personagem',
        titulo: 'Personagem',
        pk: 'id_personagem',
        rotuloPk: 'Código',
        campos: [
            { nome: 'nome', rotulo: 'Nome do personagem', tipo: 'text', obrigatorio: true, exemplo: 'Jolyne Cujoh' },
            { nome: 'descricao', rotulo: 'Descrição', tipo: 'textarea', obrigatorio: true, exemplo: 'Protagonista da Parte 6.' },
            { nome: 'id_parte', rotulo: 'Parte da obra', tipo: 'select', origem: 'parte_obra', obrigatorio: true }
        ]
    },
    stand: {
        entidade: 'stand',
        titulo: 'Stand',
        pk: 'id_stand',
        rotuloPk: 'Código',
        campos: [
            { nome: 'nome_stand', rotulo: 'Nome do stand', tipo: 'text', obrigatorio: true, exemplo: 'Stone Free' },
            { nome: 'habilidade', rotulo: 'Habilidade', tipo: 'textarea', obrigatorio: true, exemplo: 'Transforma o corpo em fios.' },
            { nome: 'id_personagem', rotulo: 'Personagem', tipo: 'select', origem: 'personagem', obrigatorio: true }
        ]
    },
    'galeria-imagem': {
        entidade: 'galeria_imagem',
        titulo: 'Imagem da galeria',
        pk: 'id_imagem',
        rotuloPk: 'Código',
        campos: [
            { nome: 'url_imagem', rotulo: 'URL ou caminho da imagem', tipo: 'text', obrigatorio: true, exemplo: 'assets/jojo.jpg' },
            { nome: 'desc_imagem', rotulo: 'Descrição da imagem (alt)', tipo: 'text', obrigatorio: true, exemplo: 'Capa da Parte 6' },
            { nome: 'id_personagem', rotulo: 'Personagem', tipo: 'select', origem: 'personagem', obrigatorio: true }
        ]
    },
    'encontro-batalha': {
        entidade: 'encontro_batalha',
        titulo: 'Encontro / batalha',
        pk: 'id_batalha',
        rotuloPk: 'Código',
        campos: [
            { nome: 'local_confronto', rotulo: 'Local do confronto', tipo: 'text', obrigatorio: true, exemplo: 'Green Dolphin Street' },
            { nome: 'desfecho', rotulo: 'Desfecho', tipo: 'textarea', obrigatorio: true, exemplo: 'Jolyne vence o confronto.' },
            { nome: 'id_personagem', rotulo: 'Personagem', tipo: 'select', origem: 'personagem', obrigatorio: true }
        ]
    }
};

const esquema = ESQUEMAS[document.body.dataset.tela];
const form = document.getElementById('formulario');
const tituloForm = document.getElementById('titulo-form');
const tabela = document.getElementById('tabela');
const mensagem = document.getElementById('mensagem');
const botaoCancelar = document.getElementById('cancelar');

let opcoes = { parte_obra: [], personagem: [] };
let registros = [];
let editando = null;

function mostrarMensagem(texto, tipo) {
    mensagem.textContent = texto;
    mensagem.className = `mensagem ${tipo}`;
    mensagem.hidden = false;
}

function limparMensagem() {
    mensagem.hidden = true;
}

function rotuloOpcao(origem, valor) {
    const item = (opcoes[origem] || []).find((o) => String(o.id) === String(valor));
    return item ? item.rotulo : valor;
}

function criarCampo(campo) {
    const grupo = document.createElement('div');
    grupo.className = 'campo';

    const label = document.createElement('label');
    label.htmlFor = campo.nome;
    label.textContent = campo.rotulo + (campo.obrigatorio ? ' *' : '');
    grupo.appendChild(label);

    let controle;

    if (campo.tipo === 'textarea') {
        controle = document.createElement('textarea');
        controle.rows = 3;
    } else if (campo.tipo === 'select') {
        controle = document.createElement('select');
        const vazio = document.createElement('option');
        vazio.value = '';
        vazio.textContent = 'Selecione...';
        controle.appendChild(vazio);
        (opcoes[campo.origem] || []).forEach((opcao) => {
            const item = document.createElement('option');
            item.value = opcao.id;
            item.textContent = opcao.rotulo;
            controle.appendChild(item);
        });
    } else {
        controle = document.createElement('input');
        controle.type = 'text';
    }

    controle.id = campo.nome;
    controle.name = campo.nome;
    controle.required = Boolean(campo.obrigatorio);
    if (campo.exemplo) controle.placeholder = `Ex.: ${campo.exemplo}`;
    grupo.appendChild(controle);

    return grupo;
}

function montarFormulario() {
    form.innerHTML = '';
    esquema.campos.forEach((campo) => form.appendChild(criarCampo(campo)));

    const acoes = document.createElement('div');
    acoes.className = 'acoes-form';

    const salvar = document.createElement('button');
    salvar.type = 'submit';
    salvar.textContent = 'Salvar';
    acoes.appendChild(salvar);

    form.appendChild(acoes);
}

function montarTabela() {
    const colunas = esquema.campos;
    let html = '<thead><tr>';
    html += `<th>${esquema.rotuloPk}</th>`;
    colunas.forEach((campo) => { html += `<th>${campo.rotulo}</th>`; });
    html += '<th>Ações</th></tr></thead><tbody>';

    if (registros.length === 0) {
        html += `<tr><td colspan="${colunas.length + 2}" class="vazio">Nenhum registro cadastrado.</td></tr>`;
    }

    registros.forEach((registro) => {
        html += `<tr><td>${registro[esquema.pk]}</td>`;
        colunas.forEach((campo) => {
            const valor = registro[campo.nome] ?? '';
            const texto = campo.tipo === 'select' ? rotuloOpcao(campo.origem, valor) : valor;
            html += `<td>${escapar(texto)}</td>`;
        });
        html += `<td class="acoes">
                    <button type="button" class="editar" data-id="${registro[esquema.pk]}">Editar</button>
                    <button type="button" class="excluir" data-id="${registro[esquema.pk]}">Excluir</button>
                 </td></tr>`;
    });

    html += '</tbody>';
    tabela.innerHTML = html;

    tabela.querySelectorAll('.editar').forEach((botao) => {
        botao.addEventListener('click', () => iniciarEdicao(Number(botao.dataset.id)));
    });
    tabela.querySelectorAll('.excluir').forEach((botao) => {
        botao.addEventListener('click', () => excluir(Number(botao.dataset.id)));
    });
}

function escapar(texto) {
    return String(texto)
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;');
}

async function carregarOpcoes() {
    const resposta = await fetch('/api/opcoes');
    if (!resposta.ok) throw new Error('Falha ao carregar as opções.');
    opcoes = await resposta.json();
}

async function carregarRegistros() {
    const resposta = await fetch(`/api/${esquema.entidade}`);
    if (!resposta.ok) throw new Error('Falha ao carregar os registros.');
    registros = await resposta.json();
    montarTabela();
}

// Carrega o registro no formulário para edição.
function iniciarEdicao(id) {
    const registro = registros.find((r) => Number(r[esquema.pk]) === id);
    if (!registro) return;

    editando = id;
    esquema.campos.forEach((campo) => {
        document.getElementById(campo.nome).value = registro[campo.nome] ?? '';
    });
    tituloForm.textContent = `Editar ${esquema.titulo.toLowerCase()} #${id}`;
    botaoCancelar.hidden = false;
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function cancelarEdicao() {
    editando = null;
    form.reset();
    tituloForm.textContent = `Cadastrar ${esquema.titulo.toLowerCase()}`;
    botaoCancelar.hidden = true;
    limparMensagem();
}

async function excluir(id) {
    if (!window.confirm(`Excluir o registro #${id}? Esta ação não pode ser desfeita.`)) return;

    const resposta = await fetch(`/api/${esquema.entidade}/${id}`, { method: 'DELETE' });
    const corpo = await resposta.json().catch(() => ({}));

    if (!resposta.ok) {
        mostrarMensagem(corpo.mensagem || 'Não foi possível excluir.', 'erro');
        return;
    }

    if (editando === id) cancelarEdicao();
    await carregarRegistros();
    mostrarMensagem(`Registro #${id} excluído.`, 'sucesso');
}

// Cadastra um novo registro (POST) ou salva a edição (PUT).
form.addEventListener('submit', async (evento) => {
    evento.preventDefault();
    limparMensagem();

    const dados = {};
    esquema.campos.forEach((campo) => {
        dados[campo.nome] = document.getElementById(campo.nome).value.trim();
    });

    const url = editando ? `/api/${esquema.entidade}/${editando}` : `/api/${esquema.entidade}`;
    const metodo = editando ? 'PUT' : 'POST';

    const resposta = await fetch(url, {
        method: metodo,
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(dados)
    });
    const corpo = await resposta.json().catch(() => ({}));

    if (!resposta.ok) {
        mostrarMensagem(corpo.mensagem || 'Não foi possível salvar.', 'erro');
        return;
    }

    const eraEdicao = Boolean(editando);
    cancelarEdicao();
    await carregarRegistros();
    mostrarMensagem(eraEdicao ? 'Registro atualizado com sucesso!' : 'Registro cadastrado com sucesso!', 'sucesso');
});

botaoCancelar.addEventListener('click', cancelarEdicao);

(async function iniciar() {
    try {
        await carregarOpcoes();
        montarFormulario();
        botaoCancelar.hidden = true;
        await carregarRegistros();
    } catch (erro) {
        console.error(erro);
        mostrarMensagem('Não foi possível carregar a tela. Verifique se o servidor e o MySQL estão ativos.', 'erro');
    }
})();
