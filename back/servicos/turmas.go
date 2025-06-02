package servicos

import (
	"biblioteca/banco"
	"biblioteca/modelos"
)

func CriarTurma(turma modelos.Turma) (modelos.Turma, bool) {
	series := PegarTodasAsSeries()
	turnos := PegarTodosOsTurnos()

	naoAchouSerie, naoAchouTurno := true, true

	for _, turno := range turnos {
		if turno.IdTurno == turma.Turno.IdTurno {
			naoAchouTurno = false
		}
	}

	for _, serie := range series {
		if serie.IdSerie == turma.Serie.IdSerie {
			naoAchouSerie = false
		}
	}

	if naoAchouSerie || naoAchouTurno {
		return modelos.Turma{}, false
	}

	return banco.CriarTurma(turma)
}

func PegarTurmaPorId(id int) (modelos.Turma, bool) {
	return banco.PegarTurmaPorId(id)
}

func PegarTodasAsTurmas() []modelos.Turma {
	return banco.PegarTodasAsTurmas()
}
