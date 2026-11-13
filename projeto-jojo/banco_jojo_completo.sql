-- Projeto Web + Banco de Dados - Catálogo JoJo
-- Lista de Exercícios - CRUD Web (LE4) - 4º Bimestre
-- Alunos: Lucas Faleiros Chagas (30665791) e Miguel Ferreira (3056058) - INFO1

CREATE DATABASE IF NOT EXISTS jojo_db
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE jojo_db;

DROP TABLE IF EXISTS encontro_batalha;
DROP TABLE IF EXISTS galeria_imagem;
DROP TABLE IF EXISTS stand;
DROP TABLE IF EXISTS personagem;
DROP TABLE IF EXISTS parte_obra;
DROP TABLE IF EXISTS obras;

-- 1) parte_obra: arco/temporada da obra
CREATE TABLE parte_obra (
    id_parte     INT NOT NULL AUTO_INCREMENT,
    numero_parte VARCHAR(50)  NOT NULL,
    nome_arco    VARCHAR(100) NOT NULL,
    PRIMARY KEY (id_parte),
    UNIQUE KEY uq_parte_numero (numero_parte)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2) personagem: entidade principal (pessoa)
CREATE TABLE personagem (
    id_personagem INT NOT NULL AUTO_INCREMENT,
    nome          VARCHAR(100) NOT NULL,
    descricao     TEXT         NOT NULL,
    id_parte      INT          NOT NULL,
    PRIMARY KEY (id_personagem),
    KEY idx_personagem_parte (id_parte),
    CONSTRAINT fk_personagem_parte
        FOREIGN KEY (id_parte) REFERENCES parte_obra (id_parte)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3) stand: poder do personagem (1:1)
CREATE TABLE stand (
    id_stand      INT NOT NULL AUTO_INCREMENT,
    nome_stand    VARCHAR(100) NOT NULL,
    habilidade    TEXT         NOT NULL,
    id_personagem INT          NOT NULL,
    PRIMARY KEY (id_stand),
    UNIQUE KEY uq_stand_personagem (id_personagem),
    CONSTRAINT fk_stand_personagem
        FOREIGN KEY (id_personagem) REFERENCES personagem (id_personagem)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4) galeria_imagem: imagens do personagem (1:N)
CREATE TABLE galeria_imagem (
    id_imagem     INT NOT NULL AUTO_INCREMENT,
    url_imagem    VARCHAR(255) NOT NULL,
    desc_imagem   VARCHAR(150) NOT NULL,
    id_personagem INT          NOT NULL,
    PRIMARY KEY (id_imagem),
    KEY idx_galeria_personagem (id_personagem),
    CONSTRAINT fk_galeria_personagem
        FOREIGN KEY (id_personagem) REFERENCES personagem (id_personagem)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5) encontro_batalha: confrontos do personagem (1:N)
CREATE TABLE encontro_batalha (
    id_batalha      INT NOT NULL AUTO_INCREMENT,
    local_confronto VARCHAR(100) NOT NULL,
    desfecho        TEXT         NOT NULL,
    id_personagem   INT          NOT NULL,
    PRIMARY KEY (id_batalha),
    KEY idx_batalha_personagem (id_personagem),
    CONSTRAINT fk_batalha_personagem
        FOREIGN KEY (id_personagem) REFERENCES personagem (id_personagem)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------
-- 1) parte_obra - 15 registros (partes do mangá/anime e obras derivadas)
-- ---------------------------------------------------------------------
INSERT INTO parte_obra (id_parte, numero_parte, nome_arco) VALUES
(1,  'Parte 1',    'Phantom Blood'),
(2,  'Parte 2',    'Battle Tendency'),
(3,  'Parte 3',    'Stardust Crusaders'),
(4,  'Parte 4',    'Diamond Is Unbreakable'),
(5,  'Parte 5',    'Golden Wind'),
(6,  'Parte 6',    'Stone Ocean'),
(7,  'Parte 7',    'Steel Ball Run'),
(8,  'Parte 8',    'JoJolion'),
(9,  'Parte 9',    'The JOJOLands'),
(10, 'OVA 1993',   'Stardust Crusaders (OVA de 1993)'),
(11, 'OVA 2000',   'Stardust Crusaders (OVA de 2000)'),
(12, 'Filme 2007', 'Phantom Blood (filme de animação)'),
(13, 'Filme 2017', 'Diamond Is Unbreakable (live-action)'),
(14, 'Spin-off',   'Thus Spoke Kishibe Rohan'),
(15, 'Jogo 2013',  'All-Star Battle');

-- ---------------------------------------------------------------------
-- 2) personagem - 20 registros (protagonistas, aliados e antagonistas)
-- ---------------------------------------------------------------------
INSERT INTO personagem (id_personagem, nome, descricao, id_parte) VALUES
(1,  'Jonathan Joestar',       'Protagonista da Parte 1. Usa Hamon e enfrenta Dio Brando para proteger a família Joestar.', 1),
(2,  'Joseph Joestar',         'Protagonista da Parte 2. Mestre do Hamon, conhecido pela astúcia e pelas previsões de fala.', 2),
(3,  'Jotaro Kujo',            'Protagonista da Parte 3. Estudante de 17 anos e usuário do Star Platinum.', 3),
(4,  'Josuke Higashikata',     'Protagonista da Parte 4. Mora em Morioh e usa o Crazy Diamond para restaurar objetos.', 4),
(5,  'Giorno Giovanna',        'Protagonista da Parte 5. Filho de DIO que entra na Passione para mudar a máfia.', 5),
(6,  'Jolyne Cujoh',           'Protagonista da Parte 6. Filha de Jotaro, presa na Penitenciária Green Dolphin.', 6),
(7,  'Johnny Joestar',         'Protagonista da Parte 7. Ex-jóquei paraplégico que disputa a corrida Steel Ball Run.', 7),
(8,  'Josuke Higashikata (8)', 'Protagonista da Parte 8. Jovem amnésico encontrado na cidade de Morioh.', 8),
(9,  'Jodio Joestar',          'Protagonista da Parte 9. Adolescente do Havaí que trabalha com entregas suspeitas.', 9),
(10, 'DIO',                    'Antagonista da Parte 3. Vampiro que desperta o Stand The World e para o tempo.', 3),
(11, 'Dio Brando',             'Antagonista da Parte 1. Irmão adotivo de Jonathan que se torna vampiro.', 1),
(12, 'Yoshikage Kira',         'Antagonista da Parte 4. Serial killer obcecado por mãos femininas.', 4),
(13, 'Diavolo',                'Antagonista da Parte 5. Chefe da Passione e usuário do King Crimson.', 5),
(14, 'Kars',                   'Antagonista da Parte 2. Líder dos Homens do Pilar e criador das máscaras de pedra.', 2),
(15, 'Enrico Pucci',           'Antagonista da Parte 6. Padre que segue o legado de DIO e busca o céu.', 6),
(16, 'Funny Valentine',        'Antagonista da Parte 7. Presidente dos Estados Unidos na corrida Steel Ball Run.', 7),
(17, 'Tooru',                  'Antagonista da Parte 8. Usuário do Wonder of U e ligado à família Higashikata.', 8),
(18, 'Bruno Bucciarati',       'Aliado da Parte 5. Capo da equipe que ajuda Giorno a entrar na Passione.', 5),
(19, 'Rohan Kishibe',          'Aliado da Parte 4. Mangaká famoso de Morioh e usuário do Heaven''s Door.', 4),
(20, 'Diego Brando',           'Rival da Parte 7. Jóquei talentoso apelidado de Dio, dono do Scary Monsters.', 7);

-- ---------------------------------------------------------------------
-- 3) stand - 16 registros (um stand por personagem, relação 1:1)
-- ---------------------------------------------------------------------
INSERT INTO stand (id_stand, nome_stand, habilidade, id_personagem) VALUES
(1,  'Hermit Purple',   'Cria vinhas que transmitem informações por fotografias e telas.', 2),
(2,  'Star Platinum',   'Força, velocidade e precisão sobre-humanas, com o golpe Ora Ora Ora.', 3),
(3,  'Crazy Diamond',   'Restaura objetos e ferimentos, mas não pode curar a si mesmo.', 4),
(4,  'Gold Experience', 'Transforma objetos inanimados em seres vivos.', 5),
(5,  'Stone Free',      'Converte o corpo em fios capazes de se esticar e amarrar inimigos.', 6),
(6,  'Tusk',            'Dispara as unhas como projéteis giratórios; evolui em quatro atos.', 7),
(7,  'Soft & Wet',      'Rouba propriedades dos objetos por meio de bolhas de sabão.', 8),
(8,  'November Rain',   'Cria gotas de chuva que atingem como balas em uma área.', 9),
(9,  'The World',       'Para o tempo por até nove segundos.', 10),
(10, 'Killer Queen',    'Transforma qualquer objeto tocado em uma bomba.', 12),
(11, 'King Crimson',    'Apaga até dez segundos de tempo e prevê o futuro próximo.', 13),
(12, 'Whitesnake',      'Extrai memórias e stands de outras pessoas em discos.', 15),
(13, 'D4C',             'Permite viajar entre universos paralelos.', 16),
(14, 'Wonder of U',     'Redireciona qualquer perseguição ao portador em forma de calamidade.', 17),
(15, 'Sticky Fingers',  'Cria zíperes em objetos e no próprio corpo.', 18),
(16, 'Heaven''s Door',  'Transforma pessoas em livros que revelam a verdade.', 19);

-- ---------------------------------------------------------------------
-- 4) galeria_imagem - 18 registros (1:N; alguns personagens têm 2 imagens)
-- ---------------------------------------------------------------------
INSERT INTO galeria_imagem (id_imagem, url_imagem, desc_imagem, id_personagem) VALUES
(1,  'assets/jojo.jpg',            'Jonathan Joestar em traje vitoriano', 1),
(2,  'assets/jojo-hamon.jpg',      'Joseph Joestar usando Hamon', 2),
(3,  'assets/jojo3.jpg',           'Jotaro Kujo com o uniforme escolar', 3),
(4,  'assets/star-platinum.jpg',   'Star Platinum ao lado de Jotaro', 3),
(5,  'assets/josuke.jpg',          'Josuke Higashikata em Morioh', 4),
(6,  'assets/crazy-diamond.jpg',   'Crazy Diamond em combate', 4),
(7,  'assets/jojo-jesus.jpg',      'Giorno Giovanna com o traje da Passione', 5),
(8,  'assets/gold-experience.jpg', 'Gold Experience ativando seu poder', 5),
(9,  'assets/jolyne.jpg',          'Jolyne Cujoh na penitenciária', 6),
(10, 'assets/johnny.jpg',          'Johnny Joestar montado em Slow Dancer', 7),
(11, 'assets/josuke8.jpg',         'Josuke da Parte 8 com a roupa de marinheiro', 8),
(12, 'assets/jodio.jpg',           'Jodio Joestar nas ruas do Havaí', 9),
(13, 'assets/dio.jpg',             'DIO no castelo no Egito', 10),
(14, 'assets/the-world.jpg',       'The World com a armadura dourada', 10),
(15, 'assets/kira.jpg',            'Yoshikage Kira em Morioh', 12),
(16, 'assets/diavolo.jpg',         'Diavolo na Itália', 13),
(17, 'assets/pucci.jpg',           'Enrico Pucci na capela da prisão', 15),
(18, 'assets/bucciarati.jpg',      'Bruno Bucciarati com o time da Passione', 18);

-- ---------------------------------------------------------------------
-- 5) encontro_batalha - 18 registros (1:N; confrontos do universo JoJo)
-- ---------------------------------------------------------------------
INSERT INTO encontro_batalha (id_batalha, local_confronto, desfecho, id_personagem) VALUES
(1,  'Mansão Joestar (Inglaterra)',    'Jonathan derrota Dio Brando, mas morre afundando com o navio.', 1),
(2,  'Castelo do Cavaleiro Negro',     'Jonathan vence o Cavaleiro Negro e aprende o Hamon.', 1),
(3,  'Arena de Roma',                  'Joseph enfrenta Wamuu e vence com o Hamon.', 2),
(4,  'Vulcão da Suíça',                'Joseph derrota Kars, que fica preso no espaço.', 2),
(5,  'Cairo (Egito)',                  'Jotaro derrota DIO e descobre que pode parar o tempo.', 3),
(6,  'Mansão de DIO',                  'Jotaro e Joseph enfrentam DIO no mesmo dia da batalha final.', 3),
(7,  'Morioh - Rua Angular',           'Josuke derrota Yoshikage Kira com a ajuda de Okuyasu e Rohan.', 4),
(8,  'Morioh - Casa dos Higashikata',  'Josuke enfrenta o pai, que volta como inimigo.', 4),
(9,  'Roma - Coliseu',                 'Giorno derrota Diavolo e assume o controle da Passione.', 5),
(10, 'Nápoles - Estação Ferroviária',  'Bucciarati enfrenta a equipe da Passione e se alia a Giorno.', 18),
(11, 'Penitenciária Green Dolphin',    'Jolyne enfrenta Pucci e tenta impedir o plano do céu.', 6),
(12, 'Cabo Canaveral',                 'Pucci acelera o tempo e reinicia o universo.', 15),
(13, 'Deserto de Nevada',              'Johnny vence a corrida e enfrenta Funny Valentine.', 7),
(14, 'Casa Branca',                    'Funny Valentine é derrotado por Johnny e Gyro.', 16),
(15, 'Morioh (Parte 8)',               'Josuke enfrenta Tooru e o Wonder of U.', 8),
(16, 'Estádio de Morioh',              'Tooru tenta eliminar Josuke durante a colheita do fruto.', 17),
(17, 'Ilha do Havaí',                  'Jodio faz a entrega e enfrenta os capangas do cartel.', 9),
(18, 'Morioh - Túnel',                 'Rohan usa o Heaven''s Door para interrogar um suspeito.', 19);

-- ---------------------------------------------------------------------
-- Verificação: contagem de registros por tabela
-- ---------------------------------------------------------------------
SELECT 'parte_obra' AS tabela, COUNT(*) AS registros FROM parte_obra
UNION ALL SELECT 'personagem',      COUNT(*) FROM personagem
UNION ALL SELECT 'stand',           COUNT(*) FROM stand
UNION ALL SELECT 'galeria_imagem',  COUNT(*) FROM galeria_imagem
UNION ALL SELECT 'encontro_batalha',COUNT(*) FROM encontro_batalha;