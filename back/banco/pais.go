package banco

import "biblioteca/modelos"
import "context"
import pgx "github.com/jackc/pgx/v5"
type ErroBancoPais int

const (
	ErroBancoPaisNenhum = iota
	ErroBancoPaisInexistente
)


func PegarPaisPeloId(idDoPais int) (modelos.Pais, bool) {
	conexao := PegarConexao()
	textoQuery := "select id_pais, nome, sigla from pais where id_pais = $1"
	var pais modelos.Pais
	if erro := conexao.QueryRow(context.Background(), textoQuery, idDoPais).Scan(
		&pais.IdDoPais,
		&pais.Nome,
		&pais.Sigla,
	); erro != nil {
		return pais, false 
	}

	return pais, true
}

func PegarTodosOsPaises() map[int]modelos.Pais {
	conexao := PegarConexao()
	textoQuery := "select id_pais, nome, sigla from pais"
	linhas, erro := conexao.Query(context.Background(), textoQuery)
	if erro != nil {
		return nil
	}
	var paisTemporario modelos.Pais
	paisesEncontrados := make(map[int]modelos.Pais)
	_, erro = pgx.ForEachRow(
		linhas,
		[]any{
			&paisTemporario.IdDoPais,
			&paisTemporario.Nome,
			&paisTemporario.Sigla, 
		},
		func () error {
			paisesEncontrados[paisTemporario.IdDoPais] = paisTemporario
			return nil
		},
	)
	if erro != nil {
		return nil
	}
	return paisesEncontrados
}
