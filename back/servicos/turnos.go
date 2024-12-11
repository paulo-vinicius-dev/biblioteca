package servicos

import (
	"biblioteca/banco"
	"biblioteca/modelos"
)

func PegarTodosOsTurnos() []modelos.Turno {
	return banco.PegarTodosOsTurnos()
}
