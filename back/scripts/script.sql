DROP TABLE IF EXISTS datelhe_emprestimo;
DROP TABLE IF EXISTS emprestimo;
DROP TABLE IF EXISTS usuario;
DROP TABLE IF EXISTS tipo_usuario;
DROP TABLE IF EXISTS exemplar_livro;
DROP TABLE IF EXISTS livro_categoria;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS livro_autor;
DROP TABLE IF EXISTS livro;
DROP TABLE IF EXISTS autor;
DROP TABLE IF EXISTS pais;


CREATE TABLE IF NOT EXISTS pais (
	id_pais SMALLINT NOT NULL,
	nome VARCHAR(255) NOT NULL UNIQUE,
	sigla VARCHAR(2) NOT NULL UNIQUE,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_pais)
);

CREATE TABLE IF NOT EXISTS autor(
	id_autor SERIAL NOT NULL,
	nome VARCHAR(255) NOT NULL UNIQUE,
	data_nascimento DATE,
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
	id_livro INT NOT NULL,
	cativo BOOLEAN NOT NULL,
	status SMALLINT DEFAULT 1 NOT NULL,
	estado SMALLINT DEFAULT 1 NOT NULL,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	PRIMARY KEY(id_exemplar_livro, id_livro),
	FOREIGN KEY(id_livro) REFERENCES livro(id_livro) 
);

CREATE TABLE IF NOT EXISTS tipo_usuario (
	id_tipo_usuario SMALLSERIAL NOT NULL,
	descricao varchar(255) NOT NULL UNIQUE,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	permissoes SMALLINT NOT NULL DEFAULT 0,
	PRIMARY KEY(id_tipo_usuario)
);

CREATE TABLE IF NOT EXISTS usuario (
	id_usuario SERIAL NOT NULL,
	login VARCHAR(255) NOT NULL UNIQUE,
	nome VARCHAR(255) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE,
	telefone VARCHAR(11),
	data_nascimento DATE,
	senha VARCHAR(255) NOT NULL,
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP,
	id_tipo_usuario SMALLINT NOT NULL,
	PRIMARY KEY(id_usuario),
	FOREIGN KEY(id_tipo_usuario) REFERENCES tipo_usuario(id_tipo_usuario)
);

CREATE TABLE IF NOT EXISTS emprestimo (
	id_exemplar_livro INT NOT NULL,
	id_livro INT NOT NULL,
	id_usuario INT NOT NULL,
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
	PRIMARY KEY(id_exemplar_livro, id_livro, id_usuario, data_emprestimo),
	FOREIGN KEY(id_livro) REFERENCES livro(id_livro),
	FOREIGN KEY(id_exemplar_livro, id_livro) REFERENCES exemplar_livro(id_exemplar_livro, id_livro),
	FOREIGN KEY(id_usuario) REFERENCES usuario(id_usuario)
);

CREATE TABLE IF NOT EXISTS detalhe_emprestimo (
	id_usuario INT NOT NULL,
	id_emprestimo INT NOT NULL,
	data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	acao SMALLINT NOT NULL,
	detalhe VARCHAR(255),
	data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	data_atualizacao TIMESTAMP
);

-- Tabela pais
INSERT INTO pais (id_pais, nome, sigla) VALUES
(1, 'Brasil', 'BR'),
(2, 'Estados Unidos', 'US'),
(3, 'Reino Unido', 'UK');

-- Tabela autor
INSERT INTO autor (nome, data_nascimento, nacionalidade, sexo) VALUES
('Machado de Assis', '1839-06-21', 1, 'M'),
('J.K. Rowling', '1965-07-31', 3, 'F'),
('George R. R. Martin', '1948-09-20', 2, 'M');

-- Tabela livro
INSERT INTO livro (isbn, titulo, ano_publicacao, editora, pais) VALUES
('9781234567897', 'Dom Casmurro', '1899-01-01', 'Editora X', 1),
('9780747532743', 'Harry Potter e a Pedra Filosofal', '1997-06-26', 'Bloomsbury', 3),
('9780553103540', 'A Game of Thrones', '1996-08-06', 'Bantam Books', 2);

-- Tabela livro_autor
INSERT INTO livro_autor (id_livro, id_autor) VALUES
(1, 1),  -- Dom Casmurro por Machado de Assis
(2, 2),  -- Harry Potter por J.K. Rowling
(3, 3);  -- A Game of Thrones por George R. R. Martin

-- Tabela categoria
INSERT INTO categoria (descricao) VALUES
('Ficção'),
('Fantasia'),
('Clássico');

-- Tabela livro_categoria
INSERT INTO livro_categoria (id_livro, id_categoria) VALUES
(1, 3),  -- Dom Casmurro é Clássico
(2, 2),  -- Harry Potter é Fantasia
(3, 2);  -- A Game of Thrones é Fantasia

-- Tabela exemplar_livro
INSERT INTO exemplar_livro (id_livro, cativo, status, estado) VALUES
(1, FALSE, 1, 1),  -- Exemplar de Dom Casmurro
(2, TRUE, 1, 2),   -- Exemplar de Harry Potter
(3, FALSE, 2, 3);  -- Exemplar de A Game of Thrones

-- Tabela tipo_usuario
INSERT INTO tipo_usuario (descricao, permissoes) VALUES
('Administrador', 1),
('Bibliotecário', 2),
('Usuário Comum', 0);

-- Tabela usuario
INSERT INTO usuario (login, nome, email, telefone, data_nascimento, senha, id_tipo_usuario) VALUES
('admin', 'Admin User', 'admin@biblioteca.com', '11123456789', '1990-01-01', 'senhaAdmin', 1),
('biblio', 'Bibliotecario', 'bibliotecario@biblioteca.com', '11123456789', '1980-05-15', 'senhaBiblio', 2),
('joao', 'João Silva', 'joao.silva@usuario.com', '11987654321', '1995-08-10', 'senhaJoao', 3);

-- Tabela emprestimo
INSERT INTO emprestimo (id_exemplar_livro, id_livro, id_usuario, data_emprestimo, data_prevista_devolucao, observacao) VALUES
(1, 1, 3, '2024-01-01', '2024-01-15', 'Primeiro empréstimo'),
(2, 2, 3, '2024-01-02', '2024-01-16', 'Devolução atrasada');

-- Tabela detalhe_emprestimo
INSERT INTO detalhe_emprestimo (id_usuario, id_emprestimo, acao, detalhe) VALUES
(3, 1, 1, 'Empréstimo realizado'),
(3, 2, 2, 'Renovação solicitada');
