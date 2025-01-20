package servicos

import "biblioteca/modelos"
import "biblioteca/banco"
import "biblioteca/utilidades"
import "biblioteca/servicos/sessao"

type ErroServicoPais int

const (
	ErroServicoPaisNenhum = iota
	ErroServicoPaisInexistente
	ErroServicoPaisExistente
	ErroServicoPaisNomeOuSiglaDuplicado
	ErroServicoPaisSessaoInvalida
	ErroServicoPaisSemPermissao
	ErroServicoPaisNomeInvalido
	ErroServicoPaisSiglaInvalida
)

func erroBancoPaisParaErroServicoPais(erro banco.ErroBancoPais) ErroServicoPais {
	switch erro {
	case banco.ErroBancoPaisInexistente:
		return ErroServicoPaisInexistente
	case banco.ErroBancoPaisExistente:
		return ErroServicoPaisExistente
	case banco.ErroBancoPaisNomeOuSiglaDuplicado:
		return ErroServicoPaisNomeOuSiglaDuplicado
	default:
		return ErroServicoPaisNenhum
	}
}
func CriarPais(idDaSessao uint64, loginDoUsuarioCriador string, novoPais modelos.Pais) (modelos.Pais, ErroServicoPais){
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioCriador) != sessao.VALIDO {
		return modelos.Pais{}, ErroServicoPaisSessaoInvalida
	}

	permissaoDoUsuario := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuario & utilidades.PermissaoPais != utilidades.PermissaoPais {
		return modelos.Pais{}, ErroServicoPaisSemPermissao
	}

	if novoPais.Nome == "" {
		return modelos.Pais{}, ErroServicoPaisNomeInvalido
	} 

	if novoPais.Sigla == "" {
		return modelos.Pais{}, ErroServicoPaisSiglaInvalida
	}
	novoPais, erro := banco.CadastrarPais(novoPais) 
	return	novoPais, erroBancoPaisParaErroServicoPais(erro)
}

func PesquisarPais(idDaSessao uint64, loginDoUsuarioPesquisador string, pais  modelos.Pais) ([]modelos.Pais, ErroServicoPais) {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioPesquisador) != sessao.VALIDO {
		return []modelos.Pais{}, ErroServicoPaisSessaoInvalida
	}
	permissaoDoUsuario := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuario & utilidades.PermissaoPais != utilidades.PermissaoPais {
		return []modelos.Pais{}, ErroServicoPaisSemPermissao
	}

	return banco.BuscarPaises(pais), ErroServicoPaisNenhum
}

func AtualizarPais(idDaSessao uint64, loginDoUsuarioRequerente string, paisComDadosAtualizados modelos.Pais) (modelos.Pais, ErroServicoPais) {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioRequerente) != sessao.VALIDO {
		return modelos.Pais{}, ErroServicoPaisSessaoInvalida
	}

	permissaoDoUsuario := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuario & utilidades.PermissaoPais != utilidades.PermissaoPais {
		return modelos.Pais{}, ErroServicoPaisSemPermissao
	}

	if paisComDadosAtualizados.Nome == "" {
		return modelos.Pais{}, ErroServicoPaisNomeInvalido
	} 

	if paisComDadosAtualizados.Sigla == "" {
		return modelos.Pais{}, ErroServicoPaisSiglaInvalida
	}

	erro := banco.AtualizarPais(paisComDadosAtualizados)

	return paisComDadosAtualizados, erroBancoPaisParaErroServicoPais(erro)
}

func DeletarPais(idDaSessao uint64, loginDoUsuarioRequerente string, idDoPais int) (modelos.Pais, ErroServicoPais) {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioRequerente) != sessao.VALIDO {
		return modelos.Pais{}, ErroServicoPaisSessaoInvalida
	}

	permissaoDoUsuario := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuario & utilidades.PermissaoPais != utilidades.PermissaoPais {
		return modelos.Pais{}, ErroServicoPaisSemPermissao
	}
	
	paisASerExcluido, achou := PegarPaisPeloId(idDoPais)
	if !achou {
		return paisASerExcluido, ErroServicoPaisInexistente
	}

	erro := erroBancoPaisParaErroServicoPais(banco.DeletarPais(paisASerExcluido))
	paisASerExcluido.Ativo = false

	return paisASerExcluido, erro

} 


func PegarPaisPeloId(idDoPais int) (modelos.Pais, bool) {
	return banco.PegarPaisPeloId(idDoPais)
}

// vai retornar um hashmap tendo como chave o id do pais e como elemento o modelo.Pais
func PegarTodosOsPaises() map[int]modelos.Pais {
	return banco.PegarTodosOsPaises()
}
