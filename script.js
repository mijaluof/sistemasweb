document.addEventListener('DOMContentLoaded', () => {
    const container = document.querySelector('.todosCards');

    if (!container) {
        console.error('O container .todosCards não foi encontrado.');
        return;
    }

    fetch('/api/lista')
        .then((resposta) => {
            if (!resposta.ok) {
                throw new Error(`Erro ao buscar o catálogo: ${resposta.status}`);
            }

            return resposta.json();
        })
        .then((listaDeObras) => {
            container.innerHTML = '';

            listaDeObras.forEach((obra) => {
                container.innerHTML += `
                    <div class="card">
                        <div class="texto">
                            <h3>${obra.titulo}</h3>
                            <p>${obra.descricao}</p>
                        </div>
                        <div class="img">
                            <img src="${obra.imagem}" alt="${obra.descImagem}">
                        </div>
                    </div>
                `;
            });
        })
        .catch((erro) => {
            console.error(erro);
            container.innerHTML = '<p>Não foi possível carregar o catálogo.</p>';
        });
});
