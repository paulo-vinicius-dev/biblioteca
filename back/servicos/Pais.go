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

// vai retornar um hashmap tendo como chave o id do pais e como elemento o modelo.Pais
func PegarTodosOsPaises() map[int]modelos.Pais {
	return banco.PegarTodosOsPaises()
}
