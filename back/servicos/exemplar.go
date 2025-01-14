package servicos

import (
	"biblioteca/banco"
	"biblioteca/modelos"
	"biblioteca/servicos/sessao"
	"biblioteca/utilidades"
)

type ErroServicoExemplar int

const (
	ErroServicoExemplarNenhum = iota
	ErroServicoExemplarLivroInexistente
	ErroServicoExemplarStatusInvalido
	ErroServicoExemplarEstadoInvalido
	ErroServicoExemplarMudouLivro
	ErroServicoExemplarExemplarInexistente
	ErroServicoExemplarSemPermissao	
)

func erroBancoExemplarParaErroServicoExemplar(erro banco.ErroBancoExemplar) ErroServicoExemplar {
	switch erro {
	case banco.ErroBancoExemplarLivroInexistente:
		return ErroServicoExemplarLivroInexistente
	case banco.ErroBancoExemplarMudouLivro:
		return ErroServicoExemplarMudouLivro
	default:
		return ErroServicoExemplarNenhum

	}
}

func CadastrarExemplar(idDaSessao uint64, novoExemplar modelos.ExemplarLivro) (modelos.ExemplarLivro, ErroServicoExemplar) {

	permissaoDoUsuarioQueEstaCadastrando := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	// NOTA: USAR A PERMISSÃO DOS LIVROS AQUI NÃO É UM ERRO
	if permissaoDoUsuarioQueEstaCadastrando & utilidades.PermissaoCriarLivro != utilidades.PermissaoCriarLivro {
		return modelos.ExemplarLivro{}, ErroServicoExemplarSemPermissao
	}

	if novoExemplar.Status < modelos.StatusExemplarLivroEmprestado || novoExemplar.Status > modelos.StatusExemplarLivroIndisponivel {
		return modelos.ExemplarLivro{}, ErroServicoExemplarStatusInvalido
	}

	if novoExemplar.Estado < modelos.EstadoExemplarBom || novoExemplar.Estado > modelos.EstadoExemplarDanificado {
		return modelos.ExemplarLivro{}, ErroServicoExemplarEstadoInvalido
	}

	novoExemplar, erro := banco.CadastrarExemplar(novoExemplar)
	return novoExemplar, erroBancoExemplarParaErroServicoExemplar(erro)
}

func PesquisarExemplares(exemplar modelos.ExemplarLivro) []modelos.ExemplarLivro {
	return banco.BuscarExemplares(exemplar)
}

func AtualizarExemplar(idDaSessao uint64, exemplarComDadosAtualizados modelos.ExemplarLivro) (modelos.ExemplarLivro, ErroServicoExemplar){
	permissaoDoUsuarioQueEstaAtualizando := sessao.PegarSessaoAtual()[idDaSessao].Permissao	
	if permissaoDoUsuarioQueEstaAtualizando & utilidades.PermissaoAtualizarLivro != utilidades.PermissaoAtualizarLivro {
		return modelos.ExemplarLivro{}, ErroServicoExemplarSemPermissao
	}
	if exemplarComDadosAtualizados.Status < modelos.StatusExemplarLivroEmprestado || exemplarComDadosAtualizados.Status > modelos.StatusExemplarLivroIndisponivel {
		return modelos.ExemplarLivro{}, ErroServicoExemplarStatusInvalido
	}

	if exemplarComDadosAtualizados.Estado < modelos.EstadoExemplarBom || exemplarComDadosAtualizados.Estado > modelos.EstadoExemplarDanificado {
		return modelos.ExemplarLivro{}, ErroServicoExemplarEstadoInvalido
	}

	exemplarComDadosAntigos, achou := banco.PegarExemplarPorId(exemplarComDadosAtualizados.IdDoExemplarLivro)
	if (!achou) {
		return	modelos.ExemplarLivro{}, ErroServicoExemplarExemplarInexistente
	}
	return exemplarComDadosAtualizados,  erroBancoExemplarParaErroServicoExemplar(banco.AtualizarExemplar(exemplarComDadosAntigos, exemplarComDadosAtualizados))

}

func DeletarExemplar(idDaSessao uint64, idDoExemplar int) (modelos.ExemplarLivro, ErroServicoExemplar) {
	permissaoDoUsuarioQueEstaDeletando := sessao.PegarSessaoAtual()[idDaSessao].Permissao	
	if permissaoDoUsuarioQueEstaDeletando & utilidades.PermissaoDeletarLivro != utilidades.PermissaoDeletarLivro {
		return modelos.ExemplarLivro{}, ErroServicoExemplarSemPermissao
	}
	exemplarASerExcluido, achou := banco.PegarExemplarPorId(idDoExemplar)
	if (!achou) {
		return	modelos.ExemplarLivro{}, ErroServicoExemplarExemplarInexistente
	}

	erro := erroBancoExemplarParaErroServicoExemplar(banco.DeletarExemplar(exemplarASerExcluido))
	if erro != ErroServicoExemplarNenhum {
		return modelos.ExemplarLivro{}, erro
	}
	
	exemplarExcluido := exemplarASerExcluido
	exemplarExcluido.Ativo = false 
					  
	return exemplarExcluido, erro
}
