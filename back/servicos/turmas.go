package servicos

import (
	"biblioteca/banco"
	"biblioteca/modelos"
)

func PegarTurmaPorId(id int) (modelos.Turma, bool) {
	return banco.PegarTurmaPorId(id)
}

func PegarTodasAsTurmas() []modelos.Turma {
	return banco.PegarTodasAsTurmas()
}
