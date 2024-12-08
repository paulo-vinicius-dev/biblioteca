package usuario

import (
	"biblioteca/banco"
	"biblioteca/modelos"
	"biblioteca/servicos/sessao"
	"biblioteca/utilidades"
	"time"
)

type ErroDeServicoDoLivro int

const (
	ErroDeServicoDoLivroNenhum = iota
	ErroDeServicoDoLivroIsbnDuplicado
	ErroDeServicoDoLivroErroDesconhecido
	ErroDeServicoDoLivroIsbnInvalido
	ErroDeServicoDoLivroSemPermisao
	ErroDeServicoDoLivroSessaoInvalida
	ErroDeServicoDoLivroCpfInvalido
	ErroDeServicoDoLivroAnoPublicaoInvalida
	ErroDeServicoDoLivroFalhaNaBusca
	ErroDeServicoDoLivroLivroInexistente
)

func erroDoBancoParaErroDeServicoDoLivro(erro banco.ErroBancoLivro) ErroDeServicoDoLivro {
	switch erro {
	case banco.ErroIsbnDuplicado:
		return ErroDeServicoDoLivroIsbnDuplicado
	default:
		return ErroDeServicoDoLivroNenhum
	}
}

func CriarLivro(idDaSessao uint64, loginUsuarioCriador string, novoLivro modelos.Livro) ErroDeServicoDoLivro {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginUsuarioCriador) != sessao.VALIDO {
		return ErroDeServicoDoLivroSessaoInvalida
	}

	permissaoDoUsuarioCriador := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuarioCriador&utilidades.PermissaoCriarUsuario != utilidades.PermissaoCriarUsuario {
		return ErroDeServicoDoLivroSemPermisao
	}
	if _, erro := time.Parse(time.DateOnly, novoLivro.AnoPublicao); erro != nil {
		return ErroDeServicoDoLivroAnoPublicaoInvalida
	}
	return erroDoBancoParaErroDeServicoDoLivro(banco.CriarLivro(novoLivro))

}

func BuscarLivro(idDaSessao uint64, loginDoUsuarioBuscador string, textoDaBusca string) ([]modelos.Livro, ErroDeServicoDoLivro) {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioBuscador) != sessao.VALIDO {
		return nil, ErroDeServicoDoLivroSessaoInvalida
	}

	permissaoDoUsuarioBuscador := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if textoDaBusca == "" {
		livros := banco.PegarTodosLivros()
		return livros, ErroDeServicoDoLivroNenhum
	}

	if permissaoDoUsuarioBuscador&utilidades.PermssaoLerUsuario != utilidades.PermssaoLerUsuario {
		return nil, ErroDeServicoDoLivroSemPermisao
	}

	livrosEncontrados := banco.PesquisarLivro(textoDaBusca)

	return livrosEncontrados, ErroDeServicoDoLivroNenhum
}

func PegarIdLivro(isbn string) int {
	return banco.PegarIdLivro(isbn)
}
