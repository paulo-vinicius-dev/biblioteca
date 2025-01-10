package servicos

import "biblioteca/modelos"
import "biblioteca/banco"

type ErroServicoPais int

const (
	ErroServicoPaisNenhum = iota
	ErroServicoPaisInexistente
)

func erroBancoPaisParaErroServicoPais(erro banco.ErroBancoPais) ErroServicoPais {
	switch erro {
	case banco.ErroBancoPaisInexistente:
		return ErroServicoPaisInexistente
	default:
		return ErroServicoPaisNenhum
	}
}

func PegarPaisPeloId(idDoPais int) (modelos.Pais, bool) {
	return banco.PegarPaisPeloId(idDoPais)
}
