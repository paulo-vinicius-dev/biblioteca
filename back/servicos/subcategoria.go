package servicos

import (
	"biblioteca/banco"
	"biblioteca/modelos"
	"biblioteca/servicos/sessao"
	"biblioteca/utilidades"
)

type ErroDeServicoDaSubcategoria int

const (
	ErroDeServicoDaSubcategoriaNenhum = iota
	ErroDeServicoDaSubcategoriaDescricaoDuplicada
	ErroDeServicoDaSubcategoriaInexistente
	ErroDeServicoDaSubcategoriaExcutarCriacao
	ErroDeServicoDaSubcategoriaExcutarAtualizacao
	ErroDeServicoDaSubcategoriaExcutarExclusao
	ErroDeServicoDaSubcategoriaSessaoInvalida
	ErroDeServicoDaSubcategoriaSemPermisao
	ErroDeServicoDaSubcategoriaFalhaNaBusca
)

func erroDoBancoParaErroDeServicoDaSubcategoria(erro banco.ErroBancoSubcategoria) ErroDeServicoDaSubcategoria {
	switch erro {
	case banco.CategoriaErroNenhum:
		return ErroDeServicoDaSubcategoriaNenhum
	case banco.ErroCategoriaDescricaoDuplicada:
		return ErroDeServicoDaSubcategoriaDescricaoDuplicada
	case banco.ErroCategoriaInexistente:
		return ErroDeServicoDaSubcategoriaInexistente
	case banco.ErroCategoriaExecutarCriacao:
		return ErroDeServicoDaSubcategoriaExcutarCriacao
	case banco.ErroCategoriaExecutarAtualizacao:
		return ErroDeServicoDaSubcategoriaExcutarAtualizacao
	case banco.ErroCategoriaExecutarExclusao:
		return ErroDeServicoDaSubcategoriaExcutarExclusao
	default:
		return ErroDeServicoDaSubcategoriaNenhum
	}
}

func CriarSubcategoria(idDaSessao uint64, loginUsuarioCriador string, novaSubcategoria modelos.Subcategoria) ErroDeServicoDaSubcategoria {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginUsuarioCriador) != sessao.VALIDO {
		return ErroDeServicoDaSubcategoriaSessaoInvalida
	}

	permissaoDoUsuarioCriador := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuarioCriador&utilidades.PermissaoCriarUsuario != utilidades.PermissaoCriarUsuario {
		return ErroDeServicoDaSubcategoriaSemPermisao
	}

	idSubcategoriaComAMesmaDescricao := PegarIdSubcategoria(novaSubcategoria.Descricao)

	if idSubcategoriaComAMesmaDescricao != 0 {
		return ErroDeServicoDaSubcategoriaDescricaoDuplicada
	}

	return erroDoBancoParaErroDeServicoDaSubcategoria(banco.CriarSubcategoria(novaSubcategoria))
}

func BuscarSubcategoria(idDaSessao uint64, loginDoUsuarioBuscador string, textoDaBusca string) ([]modelos.Subcategoria, ErroDeServicoDaSubcategoria) {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioBuscador) != sessao.VALIDO {
		return nil, ErroDeServicoDaSubcategoriaSessaoInvalida
	}

	permissaoDoUsuarioBuscador := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuarioBuscador&utilidades.PermssaoLerUsuario != utilidades.PermssaoLerUsuario {
		return nil, ErroDeServicoDaSubcategoriaSemPermisao
	}

	if textoDaBusca == "" {
		subcategorias := banco.PegarTodasSubcategorias()
		return subcategorias, ErroDeServicoDaSubcategoriaNenhum
	}

	subcategoriasEncontrados := banco.PesquisarSubcategoria(textoDaBusca)

	return subcategoriasEncontrados, ErroDeServicoDaSubcategoriaNenhum
}

func AtualizarSubcategoria(idDaSessao uint64, loginDoUsuarioRequerente string, subcategoriaComDadosAtualizados modelos.Subcategoria) (modelos.Subcategoria, ErroDeServicoDaSubcategoria) {

	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioRequerente) != sessao.VALIDO {
		return subcategoriaComDadosAtualizados, ErroDeServicoDaSubcategoriaSessaoInvalida
	}

	permissaoDoUsuarioRequerente := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuarioRequerente&utilidades.PermissaoAtualizarUsuario != utilidades.PermissaoAtualizarUsuario {
		return subcategoriaComDadosAtualizados, ErroDeServicoDaSubcategoriaSemPermisao
	}

	_, achou := PegarSubcategoriaPeloId(subcategoriaComDadosAtualizados.IdSubcategoria)

	if !achou {
		return subcategoriaComDadosAtualizados, ErroDeServicoDaSubcategoriaInexistente
	}

	idSubcategoriaComAMesmaDescricao := PegarIdSubcategoria(subcategoriaComDadosAtualizados.Descricao)

	if idSubcategoriaComAMesmaDescricao != 0 && idSubcategoriaComAMesmaDescricao != subcategoriaComDadosAtualizados.IdSubcategoria {
		return subcategoriaComDadosAtualizados, ErroDeServicoDaSubcategoriaDescricaoDuplicada
	}

	return subcategoriaComDadosAtualizados, erroDoBancoParaErroDeServicoDaSubcategoria(banco.AtualizarSubcategoria(subcategoriaComDadosAtualizados))
}

func DeletarSubcategoria(idDaSessao uint64, loginDoUsuarioRequerente string, idDaSubcategoriaQueDesejaExcluir int) ErroDeServicoDaSubcategoria {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioRequerente) != sessao.VALIDO {
		return ErroDeServicoDaSubcategoriaSessaoInvalida
	}

	permissaoDoUsuarioRequerente := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuarioRequerente&utilidades.PermissaoDeletarUsuario != utilidades.PermissaoDeletarUsuario {
		return ErroDeServicoDaSubcategoriaSemPermisao
	}

	_, achou := PegarSubcategoriaPeloId(idDaSubcategoriaQueDesejaExcluir)

	if !achou {
		return ErroDeServicoDaSubcategoriaInexistente
	}

	return erroDoBancoParaErroDeServicoDaSubcategoria(banco.ExcluirSubcategoria(idDaSubcategoriaQueDesejaExcluir))
}

func PegarIdSubcategoria(descricao string) int {
	return banco.PegarIdSubcategoria(descricao)
}

func PegarSubcategoriaPeloId(id int) (modelos.Subcategoria, bool) {
	return banco.PegarSubcategoriaPeloId(id)
}
