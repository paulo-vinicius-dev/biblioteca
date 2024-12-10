package banco

import (
	//"log"
	"biblioteca/modelos"
	"context"
)

func PegarTurmaPorId(id int) (modelos.Turma, bool) {
	conexao := PegarConexao()
	textoQuery := `select turma.id_turma, 
	   turma.descricao descricao_turma,
	   serie.id_serie id_serie,
	   serie.descricao serie_descricao,
	   turno.id_turno id_turno,
	   turno.descricao turno_descricao
from turma 
join serie on serie.id_serie = turma.serie
join turno on turno.id_turno = turma.turno
where turma.id_turma = $1;`
	var turmaEncontrada modelos.Turma
	if conexao.QueryRow(context.Background(), textoQuery, id).Scan(
		&turmaEncontrada.IdTurma,
		&turmaEncontrada.Descricao,
		&turmaEncontrada.Serie.IdSerie,
		&turmaEncontrada.Serie.Descricao,
		&turmaEncontrada.Turno.IdTurno,
		&turmaEncontrada.Turno.Descricao,
	) != nil {
		return modelos.Turma{}, false
	} else {
		return turmaEncontrada, true
	}

}
