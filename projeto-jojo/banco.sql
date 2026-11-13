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

-- Carga inicial de dados
INSERT INTO parte_obra (numero_parte, nome_arco) VALUES
('Parte 1', 'Phantom Blood'),
('Parte 2', 'Battle Tendency'),
('Parte 3', 'Stardust Crusaders'),
('Parte 4', 'Diamond Is Unbreakable'),
('Parte 5', 'Golden Wind');

INSERT INTO personagem (nome, descricao, id_parte) VALUES
('Jonathan Joestar', 'Protagonista da primeira parte, usuário de Hamon.', 1),
('Joseph Joestar', 'Protagonista da segunda parte, conhecido por sua astúcia.', 2),
('Jotaro Kujo', 'Protagonista da terceira parte e usuário do Star Platinum.', 3),
('Josuke Higashikata', 'Protagonista da quarta parte, usuário do Crazy Diamond.', 4),
('Giorno Giovanna', 'Protagonista da quinta parte e usuário do Gold Experience.', 5),
('DIO', 'Antagonista da terceira parte e usuário do The World.', 3);

INSERT INTO stand (nome_stand, habilidade, id_personagem) VALUES
('Hermit Purple', 'Permite criar vinhas roxas e obter informações por meio de imagens.', 2),
('Star Platinum', 'Possui força, precisão e velocidade extraordinárias.', 3),
('Crazy Diamond', 'Pode restaurar objetos e curar outras pessoas.', 4),
('Gold Experience', 'Pode dar vida a objetos inanimados.', 5),
('The World', 'Stand de DIO, capaz de parar o tempo.', 6);

INSERT INTO galeria_imagem (url_imagem, desc_imagem, id_personagem) VALUES
('assets/jojo.jpg', 'Imagem de Jonathan Joestar', 1),
('assets/jojo3.jpg', 'Imagem de Joseph Joestar', 2),
('assets/jojo3.jpg', 'Imagem de Jotaro Kujo', 3),
('assets/jojo.jpg', 'Imagem de Josuke Higashikata', 4),
('assets/jojo-jesus.jpg', 'Imagem de Giorno Giovanna', 5),
('assets/jojo3.jpg', 'Imagem de DIO', 6);

INSERT INTO encontro_batalha (local_confronto, desfecho, id_personagem) VALUES
('Mansão Joestar', 'Jonathan enfrenta Dio durante os acontecimentos da primeira parte.', 1),
('Ilha de Lisa Lisa', 'Joseph enfrenta Kars em um confronto decisivo.', 2),
('Egito', 'Jotaro enfrenta DIO e descobre o poder de parar o tempo.', 3),
('Morioh', 'Josuke enfrenta ameaças que colocam a cidade em perigo.', 4),
('Veneza', 'Giorno enfrenta adversários durante sua jornada na Passione.', 5);

SELECT * FROM parte_obra;
SELECT * FROM personagem;
SELECT * FROM stand;
SELECT * FROM galeria_imagem;
SELECT * FROM encontro_batalha;
