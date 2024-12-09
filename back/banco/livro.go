package banco

import (
	//"log"
	"biblioteca/modelos"
	"context"
	"fmt"

	pgx "github.com/jackc/pgx/v5"
)

type ErroBancoLivro int

const (
	ErroIsbnDuplicado = iota
)

func CriarLivro(novoLivro modelos.Livro) ErroBancoLivro {
	fmt.Print("Entrou no Criar Livro Banco")
	conexao := PegarConexao()

	if IsbnDuplicado(novoLivro.Isbn) {
		return ErroIsbnDuplicado
	}
	_, erroQuery := conexao.Exec(
		context.Background(),
		"insert into livro (isbn, titulo, ano_publicacao, editora, pais, data_criacao) VALUES ($1, $2, $3, $4, $5, current_timestamp)",
		novoLivro.Isbn,
		novoLivro.Titulo,
		novoLivro.AnoPublicao,
		novoLivro.Editora,
		novoLivro.Pais,
	)

	if erroQuery != nil {
		fmt.Println(erroQuery)
		panic("Um erro imprevisto acontesceu no cadastro do livro. Provavelmente é um bug")
	}

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

func PegarIdLivro(isbn string) int {
	conexao := PegarConexao()
	var id int
	if conexao.QueryRow(context.Background(), "select id_livro from usuario where login = $1", isbn).Scan(&id) == nil {
		return id
	} else {
		return 0
	}
}

func IsbnDuplicado(cpf string) bool {
	conexao := PegarConexao()
	qtdIsbn := 0
	if conexao.QueryRow(context.Background(), "select count(isbn) from livro u where isbn = $1", cpf).Scan(&qtdIsbn) == nil {
		return qtdIsbn > 0
	} else {
		panic("Erro ao procurar por isbn duplicado. Provavelmente é um bug")
	}
}
