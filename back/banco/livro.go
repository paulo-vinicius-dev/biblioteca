package banco

import (
	//"log"
	"biblioteca/modelos"
	"context"
	"fmt"

	pgx "github.com/jackc/pgx/v5"
)

type ErroBancoLivro int

func CriarLivro(novoLivro modelos.Livro, nomeAutores []string) ErroBancoLivro {
	conexao := PegarConexao()

	tx, _ := conexao.Begin(context.Background())

	if IsbnDuplicado(novoLivro.Isbn) {
		return ErroIsbnDuplicado
	}
	_, erroQuery := tx.Exec(context.Background(),
		"insert into livro (isbn, titulo, ano_publicacao, editora, pais, data_criacao) VALUES ($1, $2, $3, $4, $5, current_timestamp)",
		novoLivro.Isbn,
		novoLivro.Titulo,
		novoLivro.AnoPublicao,
		novoLivro.Editora,
		novoLivro.Pais,
	)

	if erroQuery != nil {
		panic("Um erro imprevisto acontesceu no cadastro do livro. Provavelmente é um bug")
	}

	var idDosAutores []int

	for _, nomeAutor := range nomeAutores {
		idDoAutor := PegarIdAutor(nomeAutor)
		if idDoAutor == 0 {
			InserirAutor(modelos.Autor{Nome: nomeAutor})
			idDoAutor = PegarIdAutor(nomeAutor)
		}
		idDosAutores = append(idDosAutores, idDoAutor)
	}

	var idDoLivro int
	tx.QueryRow(context.Background(), "select id_livro from livro where isbn = $1", novoLivro.Isbn).Scan(&idDoLivro)

	for _, idDoAutor := range idDosAutores {
		_, erroQuery := tx.Exec(
			context.Background(),
			"insert into livro_autor(id_livro, id_autor, data_criacao) values ($1, $2, current_timestamp)",
			idDoLivro,
			idDoAutor,
		)

		if erroQuery != nil {
			tx.Rollback(context.Background())
			fmt.Println(erroQuery)
			panic("Um erro imprevisto acontesceu no cadastro do livro. Provavelmente é um bug")
		}

		fmt.Printf("Autor: %v; Livro: %v\n", idDoAutor, idDoLivro)
	}

	tx.Commit(context.Background())
	return ErroNenhum
}

func PesquisarLivro(busca string) []modelos.Livro {
	conexao := PegarConexao()
	busca = "%" + busca + "%"
	textoQuery := "select id_livro, isbn, titulo, to_char(ano_publicacao, 'yyyy-mm-dd'), editora, pais from livro where isbn like $1 or titulo like $1 or ano_publicacao::varchar like $1 or editora like $1 or pais::varchar like $1"
	linhas, erro := conexao.Query(context.Background(), textoQuery, busca)
	if erro != nil {
		return []modelos.Livro{}
	}
	var livroTemporario modelos.Livro
	livrosEncontrados := make([]modelos.Livro, 0)
	_, erro = pgx.ForEachRow(linhas, []any{&livroTemporario.IdDoLivro, &livroTemporario.Isbn, &livroTemporario.Titulo, &livroTemporario.AnoPublicao, &livroTemporario.Editora, &livroTemporario.Pais}, func() error {
		livrosEncontrados = append(livrosEncontrados, livroTemporario)
		return nil
	})
	if erro != nil {
		return []modelos.Livro{}
	}
	return livrosEncontrados
}

func PegarTodosLivros() []modelos.Livro {
	fmt.Println("Entrou no pegar todos os livros")
	conexao := PegarConexao()
	textoQuery := "select id_livro, isbn, titulo, to_char(ano_publicacao, 'yyyy-mm-dd'), editora, pais from livro"
	linhas, erro := conexao.Query(context.Background(), textoQuery)
	if erro != nil {
		return []modelos.Livro{}
	}
	var livroTemporario modelos.Livro
	livrosEncontrados := make([]modelos.Livro, 0)
	_, erro = pgx.ForEachRow(linhas, []any{&livroTemporario.IdDoLivro, &livroTemporario.Isbn, &livroTemporario.Titulo, &livroTemporario.AnoPublicao, &livroTemporario.Editora, &livroTemporario.Pais}, func() error {
		livrosEncontrados = append(livrosEncontrados, livroTemporario)
		return nil
	})
	if erro != nil {
		return []modelos.Livro{}
	}
	return livrosEncontrados
}

func PegarLivroPeloId(id int) (modelos.Livro, bool) {
	conexao := PegarConexao()
	var livro modelos.Livro
	textoQuery := "select id_livro, isbn, titulo, to_char(ano_publicacao, 'yyyy-mm-dd'), editora, pais from livro where id_livro = $1"
	if erro := conexao.QueryRow(context.Background(), textoQuery, id).Scan(
		&livro.IdDoLivro,
		&livro.Isbn,
		&livro.Titulo,
		&livro.AnoPublicao,
		&livro.Editora,
		&livro.Pais,
	); erro == nil {
		return livro, true
	} else {
		return livro, false
	}
}

func AtualizarLivro(livroComDadosAntigos, livroAtualizado modelos.Livro) ErroBancoLivro {

	if livroComDadosAntigos.Isbn != livroAtualizado.Isbn && IsbnDuplicado(livroAtualizado.Isbn) {
		return ErroLoginDuplicado
	}

	conexao := PegarConexao()
	textoQuery := "update livro set isbn = $1, titulo = $2, ano_publicacao = $3, editora = $4, pais = $5, data_atualizacao = current_timestamp where id_livro = $6"
	if _, erroQuery := conexao.Query(
		context.Background(),
		textoQuery,
		livroAtualizado.Isbn,
		livroAtualizado.Titulo,
		livroAtualizado.AnoPublicao,
		livroAtualizado.Editora,
		livroAtualizado.Pais,
		livroAtualizado.IdDoLivro,
	); erroQuery != nil {
		fmt.Println(erroQuery)
		panic("Um erro desconhecido acontesceu na atualização do livro")
	}

	return ErroNenhum
}

func ExcluirLivro(idDoLivro int) ErroBancoLivro {
	conexao := PegarConexao()
	_, achou := PegarLivroPeloId(idDoLivro)
	if !achou {
		return ErroLivroInexistente
	}

	_, erroQuery := conexao.Exec(
		context.Background(),
		"delete from livro where id_livro = $1",
		idDoLivro,
	)

	if erroQuery != nil {
		fmt.Println(erroQuery)
		panic("Um erro imprevisto acontenceu na exclusão do livro. Provavelmente é um bug")
	}

	return ErroNenhum
}

func PegarIdLivro(isbn string) int {
	conexao := PegarConexao()
	var id int
	if conexao.QueryRow(context.Background(), "select id_livro from livro where isbn = $1", isbn).Scan(&id) == nil {
		return id
	} else {
		return 0
	}
}

func IsbnDuplicado(cpf string) bool {
	conexao := PegarConexao()
	qtdIsbn := 0
	if conexao.QueryRow(context.Background(), "select count(isbn) from livro where isbn = $1", cpf).Scan(&qtdIsbn) == nil {
		return qtdIsbn > 0
	} else {
		panic("Erro ao procurar por isbn duplicado. Provavelmente é um bug")
	}
}
