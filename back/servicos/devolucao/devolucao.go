package devolucao

import (
	"biblioteca/banco"
	"biblioteca/modelos"
	"biblioteca/servicos"
	"biblioteca/servicos/sessao"
	"biblioteca/utilidades"
)

func erroBancoExemplarParaErroServicoExemplar(erro banco.ErroBancoExemplar) servicos.ErroServicoExemplar {
	switch erro {
	case banco.ErroBancoExemplarLivroInexistente:
		return servicos.ErroServicoExemplarLivroInexistente
	case banco.ErroBancoExemplarMudouLivro:
		return servicos.ErroServicoExemplarMudouLivro
	default:
		return servicos.ErroServicoExemplarNenhum

	}
}

func realizarDevolucao(idDaSessao uint64, loginDoUsuarioRequerente string, exemplarComDadosAtualizados modelos.ExemplarLivro) (modelos.ExemplarLivro, servicos.ErroServicoExemplar) {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioRequerente) != sessao.VALIDO {
		return modelos.ExemplarLivro{}, servicos.ErroServicoExemplarSessaoInvalida
	}
	permissaoDoUsuarioQueEstaAtualizando := sessao.PegarSessaoAtual()[idDaSessao].Permissao
	if permissaoDoUsuarioQueEstaAtualizando&utilidades.PermissaoAtualizarExemplar != utilidades.PermissaoAtualizarExemplar {
		return modelos.ExemplarLivro{}, servicos.ErroServicoExemplarSemPermissao
	}
	if exemplarComDadosAtualizados.Status != modelos.StatusExemplarLivroEmprestado {
		return modelos.ExemplarLivro{}, servicos.ErroServicoExemplarStatusInvalido
	}

	exemplarComDadosAntigos, achou := banco.PegarExemplarPorId(exemplarComDadosAtualizados.IdDoExemplarLivro)
	if !achou {
		return modelos.ExemplarLivro{}, servicos.ErroServicoExemplarExemplarInexistente
	}
	exemplarComDadosAtualizados, _ = banco.PegarExemplarPorId(exemplarComDadosAtualizados.IdDoExemplarLivro)
	return exemplarComDadosAtualizados, erroBancoExemplarParaErroServicoExemplar(banco.AtualizarExemplar(exemplarComDadosAntigos, exemplarComDadosAtualizados))
}
