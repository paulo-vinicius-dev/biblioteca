-- Tabela autor
INSERT INTO autor (nome, ano_nascimento, nacionalidade, sexo) VALUES
('Machado de Assis', '1839', 30, 'M'), -- Brasil (id 30)
('J.K. Rowling', '1965', 184, 'F'), -- Reino Unido (id 184)
('George R. R. Martin', '1948', 70, 'M'), -- EUA (id 70)
('Clarice Lispector', '1920', 30, 'F'), -- Brasil (id 30)
('José Saramago', '1922', 181, 'M'), -- Portugal (id 181)
('Agatha Christie', '1890', 184, 'F'), -- Reino Unido (id 184)
('Gabriel García Márquez', '1927', 49, 'M'), -- Colômbia (id 49)
('Stephen King', '1947', 70, 'M'), -- EUA (id 70)
('Edgar Allan Poe', '1809', 70, 'M'), -- EUA (id 70)
('Virginia Woolf', '1882', 184, 'F'), -- Reino Unido (id 184)
('Ernest Hemingway', '1899', 70, 'M'), -- EUA (id 70)
('William Shakespeare', '1564', 184, 'M'), -- Reino Unido (id 184)
('Jane Austen', '1775', 184, 'F'), -- Reino Unido (id 184)
('Jules Verne', '1828', 76, 'M'), -- França (id 76)
('Franz Kafka', '1883', 56, 'M'), -- Croácia (id 56)
('George Orwell', '1903', 184, 'M'), -- Reino Unido (id 184)
('Fyodor Dostoevsky', '1821', 191, 'M'), -- Rússia (id 191)
('H.P. Lovecraft', '1890', 70, 'M'), -- EUA (id 70)
('Isaac Asimov', '1920', 70, 'M'), -- EUA (id 70)
('Mary Shelley', '1797', 184, 'F'), -- Reino Unido (id 184)
('Herman Melville', '1819', 70, 'M'), -- EUA (id 70)
('Lewis Carroll', '1832', 184, 'M'), -- Reino Unido (id 184)
('Tolkien', '1892', 184, 'M'); -- Reino Unido (id 184)


-- Tabela livro
INSERT INTO livro (isbn, titulo, ano_publicacao, editora, pais) VALUES
('9781234567897', 'Dom Casmurro', '1899', 'Editora X', 30), -- Brasil
('9780747532743', 'Harry Potter e a Pedra Filosofal', '1997', 'Bloomsbury', 184), -- Reino Unido
('9780553103540', 'A Game of Thrones', '1996', 'Bantam Books', 70), -- EUA
('9788575427583', 'A Hora da Estrela', '1977', 'Rocco', 30), -- Brasil
('9788535914849', 'Ensaio Sobre a Cegueira', '1995', 'Companhia das Letras', 181), -- Portugal
('9780062073488', 'Assassinato no Expresso do Oriente', '1934', 'HarperCollins', 184), -- Reino Unido
('9788437604947', 'Cem Anos de Solidão', '1967', 'Sudamericana', 49), -- Colômbia
('9780451169518', 'O Iluminado', '1977', 'Doubleday', 70), -- EUA
('9780486297442', 'O Corvo', '1845', 'Fall River Press', 70), -- EUA
('9780156035234', 'Mrs. Dalloway', '1925', 'Harcourt', 184), -- Reino Unido
('9780684801223', 'O Velho e o Mar', '1952', 'Scribner', 70), -- EUA
('9780743477109', 'Hamlet', '1603', 'Simon & Schuster', 184), -- Reino Unido
('9780141439587', 'Orgulho e Preconceito', '1813', 'Penguin', 184), -- Reino Unido
('9780553213973', '20.000 Léguas Submarinas', '1870', 'Signet', 76), -- França
('9780805209990', 'A Metamorfose', '1915', 'Schocken', 56), -- Croácia
('9780451524935', '1984', '1949', 'Secker & Warburg', 184), -- Reino Unido
('9780679734505', 'Crime e Castigo', '1866', 'Vintage', 191), -- Rússia
('9780345325815', 'O Chamado de Cthulhu', '1928', 'Arkham House', 70), -- EUA
('9780553293357', 'Eu, Robô', '1950', 'Spectra', 70), -- EUA
('9780141439471', 'Frankenstein', '1818', 'Penguin', 184), -- Reino Unido
('9780142437179', 'Moby Dick', '1851', 'Harper & Brothers', 70), -- EUA
('9780192803365', 'Alice no País das Maravilhas', '1865', 'Macmillan', 184), -- Reino Unido
('9780261103283', 'O Senhor dos Anéis', '1954', 'Allen & Unwin', 184); -- Reino Unido


-- Tabela livro_autor
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

INSERT INTO categoria (descricao) VALUES
('Romance'),
('Fantasia'),
('Ficção Científica'),
('Terror'),
('Clássico'),
('Drama'),
('Poesia');

INSERT INTO livro_categoria (id_livro, id_categoria) VALUES
(1, 1),
(2, 2),
(3, 2),
(4, 6),
(5, 6),
(6, 4),
(7, 1),
(8, 4),
(9, 7),
(10, 6),
(11, 5),
(12, 5),
(13, 1),
(14, 3),
(15, 5),
(16, 3),
(17, 5),
(18, 4),
(19, 3),
(20, 4),
(21, 5),
(22, 2),
(23, 2);





