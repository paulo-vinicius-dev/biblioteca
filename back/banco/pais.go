package banco

import "biblioteca/modelos"
import "context"

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
