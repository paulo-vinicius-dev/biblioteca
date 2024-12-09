package banco

import (
	"context"
	"fmt"
)

func AssociarLivroAutor(idLivro int, idAutor int) ErroBancoLivro {
	conexao := PegarConexao()

	_, erroQuery := conexao.Exec(
		context.Background(),
		"insert into livro_autor(id_livro, id_autor, data_criacao) values ($1, $2, current_timestamp)",
		idLivro,
		idAutor,
	)

	if erroQuery != nil {
		fmt.Println(erroQuery)
		panic("Um erro imprevisto aconteceu na Associação do livro com o autor. Provavelmente é um bug")
	}

	return ErroNenhum
}
