// Cards da galeria montados a partir de /api/home.
document.addEventListener('DOMContentLoaded', () => {
    const container = document.getElementById('cards');

    fetch('/api/home')
        .then((resposta) => {
            if (!resposta.ok) throw new Error(`Erro ao buscar a galeria: ${resposta.status}`);
            return resposta.json();
        })
        .then((personagens) => {
            if (personagens.length === 0) {
                container.innerHTML = '<p>Nenhum personagem cadastrado ainda.</p>';
                return;
            }

            container.innerHTML = personagens.map((p) => `
                <article class="card">
                    <img src="${p.imagem || ''}" alt="${p.desc_imagem || p.nome}">
                    <div class="texto">
                        <h3>${p.nome}</h3>
                        <p class="parte">${p.numero_parte} - ${p.nome_arco}</p>
                        <p>${p.descricao}</p>
                        ${p.nome_stand ? `<span class="stand">Stand: ${p.nome_stand}</span>` : ''}
                    </div>
                </article>
            `).join('');
        })
        .catch((erro) => {
            console.error(erro);
            container.innerHTML = '<p>Não foi possível carregar a galeria. Verifique o servidor e o MySQL.</p>';
        });
});
