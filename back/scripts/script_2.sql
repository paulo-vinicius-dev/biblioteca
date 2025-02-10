-- Criação do scheme caso não exista! :)
-- Há duas formas de usar o banco de dados criando um schema ou um banco separado, escolha o que mais for fácil para você
-- USANDO SCHEMA:
--DROP SCHEMA biblioteca CASCADE; -- (Cuidado ao usar esse comando)
--CREATE SCHEMA biblioteca; -- CASO QUEIRA USAR UM SCHEMA (MAIS FÁCIL, só que pode causar erros caso você possua outros schemas no mesmo banco com tabelas com o mesmo nome das utilizadas nesse script)
SET search_path TO biblioteca; -- Usado somente se você escolher criar um schema

-- CRIANDO BANCO:
--DROP DATABASE biblioteca; -- APAGA O BANCO EXISTENTE
--CREATE DATABASE biblioteca; -- CASO QUEIRA USAR UM DATASE (RECOMENDADO, mas é necessário adicionar o banco o dbeaver)


DROP TABLE IF EXISTS detalhe_emprestimo;
DROP TABLE IF EXISTS emprestimo;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS turma;
DROP TABLE IF EXISTS serie;
DROP TABLE IF EXISTS turno;
DROP TABLE IF EXISTS exemplar_livro;
DROP TABLE IF EXISTS livro_categoria;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS livro_autor;
DROP TABLE IF EXISTS livro;
DROP TABLE IF EXISTS autor;
DROP TABLE IF EXISTS pais;


CREATE TABLE IF NOT EXISTS turno(
	id_turno SERIAL NOT NULL,
	descricao VARCHAR(255) NOT NULL UNIQUE,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_turno)
);


CREATE TABLE IF NOT EXISTS serie(
	id_serie SERIAL NOT NULL,
	descricao VARCHAR(255) NOT NULL UNIQUE,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_serie)
);


CREATE TABLE IF NOT EXISTS turma(
	id_turma SERIAL NOT NULL,
	descricao VARCHAR(255) NOT NULL,
	serie INT NOT NULL,
	turno INT NOT NULL,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_turma),
	UNIQUE(descricao, serie, turno),
	FOREIGN KEY(serie) REFERENCES serie(id_serie),
	FOREIGN KEY(turno) REFERENCES turno(id_turno)
);




CREATE TABLE IF NOT EXISTS pais (
	id_pais SMALLINT NOT NULL,
	nome VARCHAR(255) NOT NULL UNIQUE,
	sigla VARCHAR(2) NOT NULL UNIQUE,
	ativo bool not null,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_pais)
);


CREATE TABLE IF NOT EXISTS autor(
	id_autor SERIAL NOT NULL,
	nome VARCHAR(255) NOT NULL UNIQUE,
	ano_nascimento SMALLINT ,
	nacionalidade SMALLINT,
	sexo CHAR,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_autor),
	FOREIGN KEY(nacionalidade) REFERENCES pais(id_pais) 
);




CREATE TABLE IF NOT EXISTS livro(
	id_livro SERIAL NOT NULL,
	isbn VARCHAR(13) NOT NULL UNIQUE,
	titulo VARCHAR(255) NOT NULL,
	ano_publicacao DATE,
	editora VARCHAR(255),
	pais SMALLINT,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_livro),
	FOREIGN KEY(pais) REFERENCES pais(id_pais)
);


CREATE TABLE IF NOT EXISTS livro_autor(
	id_livro INT NOT NULL,
	id_autor INT NOT NULL,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_livro, id_autor),
	FOREIGN KEY(id_livro) REFERENCES livro(id_livro),
	FOREIGN KEY(id_autor) REFERENCES autor(id_autor)
);


CREATE TABLE IF NOT EXISTS categoria (
	id_categoria SERIAL NOT NULL,
	descricao VARCHAR(255) NOT NULL UNIQUE,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_categoria)
);


CREATE TABLE IF NOT EXISTS livro_categoria (
	id_livro INT NOT NULL,
	id_categoria INT NOT NULL,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_livro, id_categoria),
	FOREIGN KEY(id_livro) REFERENCES livro(id_livro),
	FOREIGN KEY(id_categoria) REFERENCES categoria(id_categoria)
);


CREATE TABLE IF NOT EXISTS exemplar_livro (
	id_exemplar_livro SERIAL NOT NULL,
	livro INT NOT NULL,
	cativo BOOLEAN NOT NULL,
	status SMALLINT DEFAULT 1 NOT NULL,
	estado SMALLINT DEFAULT 1 NOT NULL,
	ativo  BOOLEAN NOT NULL DEFAULT TRUE,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_exemplar_livro),
	FOREIGN KEY(livro) REFERENCES livro(id_livro) 
);


CREATE TABLE IF NOT EXISTS usuario (
	id_usuario SERIAL NOT NULL,
	login VARCHAR(255) NOT NULL UNIQUE,
	cpf VARCHAR(12),
	nome VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	telefone VARCHAR(11),
	data_nascimento DATE,
	senha VARCHAR(255) NOT NULL,
	permissoes BIGINT NOT NULL,
	ativo BOOLEAN NOT NULL DEFAULT TRUE,
	turma INT DEFAULT NULL,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_usuario),
	FOREIGN KEY(turma) REFERENCES turma(id_turma)
);


CREATE TABLE IF NOT EXISTS emprestimo (
	id_emprestimo SERIAL NOT null,
	exemplar_livro INT NOT NULL,
	usuario INT NOT NULL,
	data_emprestimo DATE NOT NULL,
	num_renovacoes smallint DEFAULT 0,
	data_prevista_devolucao DATE NOT NULL,
	data_devolucao DATE,
	valor_multa SMALLINT DEFAULT 0 CHECK(valor_multa >= 0),
	valor_adicionais SMALLINT DEFAULT 0 CHECK(valor_multa >= 0),
	--total_multa SMALLINT DEFAULT 0,
	observacao VARCHAR(255),
	status smallint DEFAULT 1,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_emprestimo),
	FOREIGN KEY(exemplar_livro) REFERENCES exemplar_livro(id_exemplar_livro),
	FOREIGN KEY(usuario) REFERENCES usuario(id_usuario)
);


CREATE TABLE IF NOT EXISTS detalhe_emprestimo (
	id_detalhe_emprestimo SERIAL NOT NULL,
	usuario INT NOT NULL,
	emprestimo INT NOT NULL,
	data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	acao SMALLINT NOT NULL,
	detalhe VARCHAR(255),
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	primary key(id_detalhe_emprestimo),
	foreign key (usuario) references usuario(id_usuario),
	foreign key (emprestimo) references emprestimo(id_emprestimo)
);

-- Tabela pais
INSERT INTO pais (id_pais, nome, sigla, ativo) VALUES
(1, 'Brasil', 'BR', true),
(2, 'Estados Unidos', 'US', true),
(3, 'Reino Unido', 'UK', true);


-- Tabela autor
INSERT INTO autor (nome, ano_nascimento, nacionalidade, sexo) VALUES
('Machado de Assis', '1839', 1, 'M'),
('J.K. Rowling', '1965', 3, 'F'),
('George R. R. Martin', '1948', 2, 'M'),
('Clarice Lispector', '1920', 1, 'F'),
('José Saramago', '1922', 3, 'M'),
('Agatha Christie', '1890', 3, 'F'),
('Gabriel García Márquez', '1927', 2, 'M'),
('Stephen King', '1947', 2, 'M'),
('Edgar Allan Poe', '1809', 3, 'M'),
('Virginia Woolf', '1882', 3, 'F'),
('Ernest Hemingway', '1899', 2, 'M'),
('William Shakespeare', '1564', 3, 'M'),
('Jane Austen', '1775', 3, 'F'),
('Jules Verne', '1828', 3, 'M'),
('Franz Kafka', '1883', 3, 'M'),
('George Orwell', '1903', 3, 'M'),
('Fyodor Dostoevsky', '1821', 3, 'M'),
('H.P. Lovecraft', '1890', 2, 'M'),
('Isaac Asimov', '1920', 2, 'M'),
('Mary Shelley', '1797', 3, 'F'),
('Herman Melville', '1819', 3, 'M'),
('Lewis Carroll', '1832', 3, 'M'),
('Tolkien', '1892', 3, 'M');


-- Tabela livro
INSERT INTO livro (isbn, titulo, ano_publicacao, editora, pais) VALUES
('9781234567897', 'Dom Casmurro', '1899-01-01', 'Editora X', 1),
('9780747532743', 'Harry Potter e a Pedra Filosofal', '1997-06-26', 'Bloomsbury', 3),
('9780553103540', 'A Game of Thrones', '1996-08-06', 'Bantam Books', 2),
('9788575427583', 'A Hora da Estrela', '1977-01-01', 'Rocco', 1),
('9788535914849', 'Ensaio Sobre a Cegueira', '1995-01-01', 'Companhia das Letras', 3),
('9780062073488', 'Assassinato no Expresso do Oriente', '1934-01-01', 'HarperCollins', 3),
('9788437604947', 'Cem Anos de Solidão', '1967-05-30', 'Sudamericana', 2),
('9780451169518', 'O Iluminado', '1977-01-28', 'Doubleday', 2),
('9780486297442', 'O Corvo', '1845-01-01', 'Fall River Press', 3),
('9780156035234', 'Mrs. Dalloway', '1925-05-14', 'Harcourt', 3),
('9780684801223', 'O Velho e o Mar', '1952-09-01', 'Scribner', 2),
('9780743477109', 'Hamlet', '1603-01-01', 'Simon & Schuster', 3),
('9780141439587', 'Orgulho e Preconceito', '1813-01-28', 'Penguin', 3),
('9780553213973', '20.000 Léguas Submarinas', '1870-03-20', 'Signet', 3),
('9780805209990', 'A Metamorfose', '1915-10-01', 'Schocken', 3),
('9780451524935', '1984', '1949-06-08', 'Secker & Warburg', 3),
('9780679734505', 'Crime e Castigo', '1866-01-01', 'Vintage', 3),
('9780345325815', 'O Chamado de Cthulhu', '1928-02-01', 'Arkham House', 2),
('9780553293357', 'Eu, Robô', '1950-12-02', 'Spectra', 2),
('9780141439471', 'Frankenstein', '1818-01-01', 'Penguin', 3),
('9780142437179', 'Moby Dick', '1851-10-18', 'Harper & Brothers', 3),
('9780192803365', 'Alice no País das Maravilhas', '1865-11-26', 'Macmillan', 3),
('9780261103283', 'O Senhor dos Anéis', '1954-07-29', 'Allen & Unwin', 3);


- Tabela livro_autor
INSERT INTO livro_autor (id_livro, id_autor) VALUES
(1, 1),  -- Dom Casmurro por Machado de Assis
(2, 2),  -- Harry Potter por J.K. Rowling
(3, 3),  -- A Game of Thrones por George R. R. Martin
(4, 4),  -- A Hora da Estrela por Clarice Lispector
(5, 5),  -- Ensaio Sobre a Cegueira por José Saramago
(6, 6),  -- Assassinato no Expresso do Oriente por Agatha Christie
(7, 7),  -- Cem Anos de Solidão por Gabriel García Márquez
(8, 8),  -- O Iluminado por Stephen King
(9, 9),  -- O Corvo por Edgar Allan Poe
(10, 10), -- Mrs. Dalloway por Virginia Woolf
(11, 11), -- O Velho e o Mar por Ernest Hemingway
(12, 12), -- Hamlet por William Shakespeare
(13, 13), -- Orgulho e Preconceito por Jane Austen
(14, 14), -- 20.000 Léguas Submarinas por Jules Verne
(15, 15), -- A Metamorfose por Franz Kafka
(16, 16), -- 1984 por George Orwell
(17, 17), -- Crime e Castigo por Fyodor Dostoevsky
(18, 18), -- O Chamado de Cthulhu por H.P. Lovecraft
(19, 19), -- Eu, Robô por Isaac Asimov
(20, 20), -- Frankenstein por Mary Shelley
(21, 21), -- Moby Dick por Herman Melville
(22, 22), -- Alice no País das Maravilhas por Lewis Carroll
(23, 23); -- O Senhor dos Anéis por J.R.R. Tolkien


-- Tabela categoria
INSERT INTO categoria (descricao) VALUES
('Ficção'),
('Fantasia'),
('Clássico'),
('Terror'),
('Romance'),
('Mistério'),
('Sci-Fi'),
('Drama'),
('Aventura'),
('Suspense');

-- Tabela livro_categoria
INSERT INTO livro_categoria (id_livro, id_categoria) VALUES
(1, 3),  -- Dom Casmurro é Clássico
(2, 2),  -- Harry Potter é Fantasia
(3, 2),  -- A Game of Thrones é Fantasia
(4, 3),  -- A Hora da Estrela é Clássico
(5, 8),  -- Ensaio Sobre a Cegueira é Drama
(6, 6),  -- Assassinato no Expresso do Oriente é Mistério
(7, 1),  -- Cem Anos de Solidão é Ficção
(8, 4),  -- O Iluminado é Terror
(9, 4),  -- O Corvo é Terror
(10, 5), -- Mrs. Dalloway é Romance
(11, 3), -- O Velho e o Mar é Clássico
(12, 3), -- Hamlet é Clássico
(13, 5), -- Orgulho e Preconceito é Romance
(14, 9), -- 20.000 Léguas Submarinas é Aventura
(15, 1), -- A Metamorfose é Ficção
(16, 1), -- 1984 é Ficção
(17, 3), -- Crime e Castigo é Clássico
(18, 4), -- O Chamado de Cthulhu é Terror
(19, 7), -- Eu, Robô é Sci-Fi
(20, 4), -- Frankenstein é Terror
(21, 9), -- Moby Dick é Aventura
(22, 9), -- Alice no País das Maravilhas é Aventura
(23, 2); -- O Senhor dos Anéis é Fantasia

-- Tabela exemplar_livro
INSERT INTO exemplar_livro (id_exemplar_livro, livro, cativo, status, estado) VALUES
(1, 1, FALSE, 1, 1),  -- Exemplar de Dom Casmurro
(2, 2, TRUE, 1, 2),   -- Exemplar de Harry Potter
(3, 3, FALSE, 2, 2),  -- Exemplar de A Game of Thrones
(4, 4, FALSE, 1, 1),  -- Exemplar de A Hora da Estrela
(5, 5, TRUE, 1, 2),   -- Exemplar de Ensaio Sobre a Cegueira
(6, 6, FALSE, 1, 1),  -- Exemplar de Assassinato no Expresso do Oriente
(7, 7, TRUE, 2, 2),   -- Exemplar de Cem Anos de Solidão
(8, 8, FALSE, 1, 1),  -- Exemplar de O Iluminado
(9, 9, TRUE, 1, 2),   -- Exemplar de O Corvo
(10, 10, FALSE, 2, 2), -- Exemplar de Mrs. Dalloway
(11, 11, TRUE, 1, 1), -- Exemplar de O Velho e o Mar
(12, 12, FALSE, 1, 2), -- Exemplar de Hamlet
(13, 13, TRUE, 2, 1), -- Exemplar de Orgulho e Preconceito
(14, 14, FALSE, 1, 1), -- Exemplar de 20.000 Léguas Submarinas
(15, 15, TRUE, 1, 2), -- Exemplar de A Metamorfose
(16, 16, FALSE, 2, 1), -- Exemplar de 1984
(17, 17, TRUE, 1, 2), -- Exemplar de Crime e Castigo
(18, 18, FALSE, 1, 1), -- Exemplar de O Chamado de Cthulhu
(19, 19, TRUE, 2, 2), -- Exemplar de Eu, Robô
(20, 20, FALSE, 1, 1), -- Exemplar de Frankenstein
(21, 21, TRUE, 1, 2), -- Exemplar de Moby Dick
(22, 22, FALSE, 2, 1), -- Exemplar de Alice no País das Maravilhas
(23, 23, TRUE, 1, 2); -- Exemplar de O Senhor dos Anéis

-- Poque as vezes o postgres ferra a sequência do serial
-- estou colacando a sequencia para avançar mais um apartir do max(id)
-- eu sei isso já deveria ser automático, mas eu deu pal no meu pc. :(
select setval((select pg_get_serial_sequence('exemplar_livro', 'id_exemplar_livro')), (select max(id_exemplar_livro) from exemplar_livro) + 1);


-- CriarUsuario = 0b1
-- LerUsuario = 0b10
-- AtualizarUsuario = 0b100
-- DeletarUsuario = 0b1000

INSERT INTO turno (id_turno, descricao) VALUES
(1, 'Manhã'),
(2, 'Tarde'),
(3, 'Noite'),
(4, 'Integral');


INSERT INTO serie (id_serie, descricao) VALUES
(1, '1º Ano'),
(2, '2º Ano'),
(3, '3º Ano');


INSERT INTO turma (id_turma, descricao, serie, turno) VALUES
(1, 'A', 1, 1),
(2, 'B', 1, 1),
(3, 'C', 1, 1),
(4, 'A', 1, 2),
(5, 'B', 1, 2),
(6, 'C', 1, 2),
(7, 'A', 1, 3),
(8, 'B', 1, 3),
(9, 'C', 1, 3),
(10, 'A', 1, 4),
(11, 'B', 1, 4),
(12, 'C', 1, 4),
(13, 'A', 2, 1),
(14, 'B', 2, 1),
(15, 'C', 2, 1),
(16, 'A', 2, 2),
(17, 'B', 2, 2),
(18, 'C', 2, 2),
(19, 'A', 2, 3),
(20, 'B', 2, 3),
(21, 'C', 2, 3),
(22, 'A', 2, 4),
(23, 'B', 2, 4),
(24, 'C', 2, 4),
(25, 'A', 3, 1),
(26, 'B', 3, 1),
(27, 'C', 3, 1),
(28, 'A', 3, 2),
(29, 'B', 3, 2),
(30, 'C', 3, 2),
(31, 'A', 3, 3),
(32, 'B', 3, 3),
(33, 'C', 3, 3),
(34, 'A', 3, 4),
(35, 'B', 3, 4),
(36, 'C', 3, 4);

-- Tabela usuario
INSERT INTO usuario (login, cpf, nome, email, telefone, data_nascimento, senha, permissoes) VALUES
('admin','21747274046', 'Admin User', 'admin@biblioteca.com', '11123456789', '1990-01-01', 'ea4a6e5c2c9f8239b566c1dc4ef972514f159ebd61d046168688a2c8531a4bf3',  2047), -- senhaAdmin
('biblio','76784092066', 'Bibliotecario', 'bibliotecario@biblioteca.com', '11123456789', '1980-05-15', '76cc71b64516994b050bdb5a79c50865654e551ae126492ee20d08047e841a86',  2047), --senhaBiblio
('joao','26843511040', 'João Silva', 'joao.silva@usuario.com', '11987654321', '1995-08-10', 'bffeba2cd38fb42e180da0254a7893f6db46e3cb2a93ff5e9b5494ce789e1006',  1), --senhaJoao
('maria123', '12345678901', 'Maria Oliveira', 'maria.oliveira@email.com', '11987651234', '1992-03-15', 'hash_senha1', 1),
('carlos_rj', '23456789012', 'Carlos Mendes', 'carlos.mendes@email.com', '21987651234', '1987-07-22', 'hash_senha2', 1),
('ana_paula', '34567890123', 'Ana Paula Souza', 'ana.souza@email.com', '11976543210', '1995-12-30', 'hash_senha3', 1),
('pedro_santos', '45678901234', 'Pedro Santos', 'pedro.santos@email.com', '31987654321', '1993-05-18', 'hash_senha4', 1),
('lucas_sp', '56789012345', 'Lucas Almeida', 'lucas.almeida@email.com', '11965432109', '1998-06-25', 'hash_senha5', 1),
('juliana_rj', '67890123456', 'Juliana Lima', 'juliana.lima@email.com', '21954321098', '1990-09-14', 'hash_senha6', 1),
('roberto_mg', '78901234567', 'Roberto Costa', 'roberto.costa@email.com', '31943210987', '1985-11-23', 'hash_senha7', 1),
('fernanda_sc', '89012345678', 'Fernanda Ribeiro', 'fernanda.ribeiro@email.com', '47932109876', '1997-04-08', 'hash_senha8', 1),
('marcos_bh', '90123456789', 'Marcos Silva', 'marcos.silva@email.com', '31921098765', '1994-01-17', 'hash_senha9', 1),
('amanda_sp', '01234567890', 'Amanda Rocha', 'amanda.rocha@email.com', '11910987654', '1996-07-09', 'hash_senha10', 1),
('joana_pr', '09876543210', 'Joana Pereira', 'joana.pereira@email.com', '41987654321', '1988-02-21', 'hash_senha11', 1),
('felipe_rs', '08765432109', 'Felipe Martins', 'felipe.martins@email.com', '51976543210', '1999-08-15', 'hash_senha12', 1),
('beatriz_pe', '07654321098', 'Beatriz Fernandes', 'beatriz.fernandes@email.com', '81965432109', '1991-10-30', 'hash_senha13', 1),
('renato_ce', '06543210987', 'Renato Araújo', 'renato.araujo@email.com', '85954321098', '1993-03-11', 'hash_senha14', 1),
('gabriela_rn', '05432109876', 'Gabriela Nunes', 'gabriela.nunes@email.com', '84943210987', '1992-12-19', 'hash_senha15', 1),
('tiago_ba', '04321098765', 'Tiago Lima', 'tiago.lima@email.com', '71932109876', '1997-05-24', 'hash_senha16', 1),
('aline_ma', '03210987654', 'Aline Castro', 'aline.castro@email.com', '98921098765', '1990-06-17', 'hash_senha17', 1),
('paulo_go', '02109876543', 'Paulo Henrique', 'paulo.henrique@email.com', '62910987654', '1998-09-28', 'hash_senha18', 1),
('vanessa_ms', '01098765432', 'Vanessa Moreira', 'vanessa.moreira@email.com', '67909876543', '1995-11-06', 'hash_senha19', 1),
('rodrigo_mt', '01987654321', 'Rodrigo Freitas', 'rodrigo.freitas@email.com', '65987654321', '1986-01-04', 'hash_senha20', 1);

update usuario set turma = 1 where login = 'joao';
update usuario set turma = 2 where login = 'maria123';
update usuario set turma = 3 where login = 'carlos_rj';
update usuario set turma = 4 where login = 'ana_paula';
update usuario set turma = 5 where login = 'pedro_santos';
update usuario set turma = 6 where login = 'lucas_sp';
update usuario set turma = 7 where login = 'juliana_rj';
update usuario set turma = 8 where login = 'roberto_mg';
update usuario set turma = 9 where login = 'fernanda_sc';
update usuario set turma = 10 where login = 'marcos_bh';
update usuario set turma = 11 where login = 'amanda_sp';
update usuario set turma = 12 where login = 'joana_pr';
update usuario set turma = 13 where login = 'felipe_rs';
update usuario set turma = 14 where login = 'beat';
update usuario set turma = 15 where login = 'renato_ce';
update usuario set turma = 16 where login = 'gabriela_rn';
update usuario set turma = 17 where login = 'tiago_ba';
update usuario set turma = 18 where login = 'aline_ma';
update usuario set turma = 19 where login = 'paulo_go';
update usuario set turma = 20 where login = 'vanessa_ms';
update usuario set turma = 21 where login = 'rodrigo_mt';

-- Tabela emprestimo
INSERT INTO emprestimo (id_emprestimo, exemplar_livro, usuario, data_emprestimo, data_prevista_devolucao, observacao) VALUES
(1, 1, 3, '2024-01-01', '2024-01-15', 'Primeiro empréstimo'),
(2, 2, 3, '2024-01-02', '2024-01-16', 'Devolução atrasada');


-- Tabela detalhe_emprestimo
INSERT INTO detalhe_emprestimo (id_detalhe_emprestimo, usuario, emprestimo, acao, detalhe) VALUES
(1, 3, 1, 1, 'Empréstimo realizado'),
(2, 3, 2, 2, 'Renovação solicitada');
