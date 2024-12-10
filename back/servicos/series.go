package servicos

import (
	"biblioteca/banco"
	"biblioteca/modelos"
)

func PegarTodasAsSeries() []modelos.Serie {
	return banco.PegarTodasAsSeries()
}
