package servicos

import (
	"biblioteca/banco"
	"biblioteca/modelos"
)

type ErroServicoExemplar int

const (
	ErroServicoExemplarNenhum = iota
	ErroServicoExemplarLivroInexistente
	ErroServicoExemplarStatusInvalido
	ErroServicoExemplarEstadoInvalido
)

func erroBancoExemplarParaErroServicoExemplar(erro banco.ErroBancoExemplar) ErroServicoExemplar {
	switch erro {
	case banco.ErroBancoExemplarLivroInexistente:
		return ErroServicoExemplarLivroInexistente
	default:
		return ErroServicoExemplarNenhum
	}
}

func CadastrarExemplar(novoExemplar modelos.ExemplarLivro) (modelos.ExemplarLivro, ErroServicoExemplar) {
	if novoExemplar.Status < modelos.StatusExemplarLivroEmprestado || novoExemplar.Status > modelos.StatusExemplarLivroIndisponivel {
		return modelos.ExemplarLivro{}, ErroServicoExemplarStatusInvalido
	}

	if novoExemplar.Estado < modelos.EstadoExemplarBom || novoExemplar.Estado > modelos.EstadoExemplarDanificado {
		return modelos.ExemplarLivro{}, ErroServicoExemplarEstadoInvalido
	}

	novoExemplar, erro := banco.CadastrarExemplar(novoExemplar)
	return novoExemplar, erroBancoExemplarParaErroServicoExemplar(erro)
}

func PesquisarUsuario(exemplar modelos.ExemplarLivro) []modelos.ExemplarLivro {
	return banco.BuscarExemplares(exemplar)
}
