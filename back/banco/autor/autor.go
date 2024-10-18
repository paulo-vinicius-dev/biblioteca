package banco

import (
	"biblioteca/banco"
	"biblioteca/modelos"
	"context"
	"fmt"
)

// VisualizarAutores realizar o SELECT no banco de dados, pegar todos os registros da tabela de autor
func VisualizarAutores() ([]modelos.Autor, error) {
	conexao := banco.PegarConexao()

	var autores []modelos.Autor

	linhas, err := conexao.Query(context.Background(),
		`SELECT id_autor,
			nome,
			data_nascimento,
			nacionalidade,
			sexo,
			data_criacao,
			data_atualizacao
		FROM autores`,
		nil,
	)
	if err != nil {
		return autores, err
	}

	fmt.Println(linhas)
	return autores, nil
}

// InserirAutor realizar o INSERT no banco de dados, pegando como base os parametros da Struct Autor
func InserirAutor(a modelos.Autor) error {
	conexao := banco.PegarConexao()

	if _, err := conexao.Exec(context.Background(), `
		INSERT INTO autor (nome, data_nascimento, nacionalidade, sexo)
		VALUES ($1, $2, $3, $4)`,
		a.Nome,
		a.DataNascimento.Format("2006-01-02"),
		a.Nacionalidade,
		a.Sexo,
	); err != nil {
		return err
	}

	return nil
}

// AtualizarAutor realizar o UPDATE no banco de dados, pegando como base os parametros da Struct Autor
func AtualizarAutor(a modelos.Autor) error {
	conexao := banco.PegarConexao()

	if _, err := conexao.Exec(context.Background(), `
		UPDATE autor
		SET nome = $1,
			data_nascimento = $2,
			nacionalidade = $3,
			sexo = $4,
			data_atualizacao = CURRENT_TIMESTAMP
		WHERE id_autor = $5`,
		a.Nome,
		a.DataNascimento.Format("2006-01-02"),
		a.Nacionalidade,
		a.Sexo,
		a.ID,
	); err != nil {
		return err
	}

	return nil
}

// ExcluirAutor realizar o DELETE no banco de dados, pegando como base os parametros da Struct Autor
func ExcluirAutor(a modelos.Autor) error {
	conexao := banco.PegarConexao()

	if _, err := conexao.Exec(context.Background(), `
		DELETE FROM autor
		WHERE id_autor = $1`,
		a.ID,
	); err != nil {
		return err
	}

	return nil
}
