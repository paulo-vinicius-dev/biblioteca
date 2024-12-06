package banco

import (
	"biblioteca/modelos"
	pgx "github.com/jackc/pgx/v5"
	"context"
)


func PegarTodasAsSeries() []modelos.Serie {
	conexao := PegarConexao()
	textoQuery := "select id_serie, descricao from serie"
	
	linhas, erro := conexao.Query(context.Background(), textoQuery)
	if erro != nil {
		return []modelos.Serie{}
	}
	seriesEncontradas := make([]modelos.Serie, 0, 3)
	var serieTemporaria modelos.Serie
	_, erro = pgx.ForEachRow(linhas, []any{&serieTemporaria.IdSerie, &serieTemporaria.Descricao}, func () error {
		seriesEncontradas = append(seriesEncontradas, serieTemporaria)
		return nil
	})
	if erro != nil {
		return []modelos.Serie{}
	}

	return seriesEncontradas
}

func PegarSeriePorId(idSerie int) (modelos.Serie, bool) {
	conexao := PegarConexao()
	textoQuery := "select id_serie, descricao from serie where id_serie = $1"
	var serieEncontrada modelos.Serie
	if erro := conexao.QueryRow(context.Background(), textoQuery, idSerie).Scan(
		&serieEncontrada.IdSerie,
		&serieEncontrada.Descricao,
	); erro == nil {
		return serieEncontrada, false
	} else {
		return serieEncontrada, true
	}
}