package banco

import (
	//"log"
	"biblioteca/modelos"
	"context"

	"github.com/jackc/pgx/v5"
)

func PegarTodosOsTurnos() []modelos.Turno {
	conexao := PegarConexao()
	textoQuery := "select id_turno, descricao from turno t"
	linhas, erro := conexao.Query(context.Background(), textoQuery)
	if erro != nil {
		return []modelos.Turno{}
	}
	turnosEncontrados := make([]modelos.Turno, 0, 4)
	var turnoTemporario modelos.Turno
	_, erro = pgx.ForEachRow(linhas, []any{&turnoTemporario.IdTurno, &turnoTemporario.Descricao}, func() error {
		turnosEncontrados = append(turnosEncontrados, turnoTemporario)
		return nil
	})
	if erro != nil {
		return []modelos.Turno{}
	}
	return turnosEncontrados
}
