package usuario

import (
	"biblioteca/banco"
	"biblioteca/modelos"
	"biblioteca/servicos/sessao"
	"biblioteca/utilidades"
	"fmt"
	"time"
)

type ErroDeServicoDoUsuario int

const (
	ErroDeServicoDoUsuarioNenhum = iota
	ErroDeServicoDoUsuarioLoginDuplicado
	ErroDeServicoDoUsuarioCpfDuplicado
	ErroDeServicoDoUsuarioEmailDuplicado
	ErroDeServicoDoUsuarioErroDesconhecido
	ErroDeServicoDoUsuarioTelefoneInvalido
	ErroDeServicoDoUsuarioSemPermisao
	ErroDeServicoDoUsuarioSessaoInvalida
	ErroDeServicoDoUsuarioCpfInvalido
	ErroDeServicoDoUsuarioDataDeNascimentoInvalida
	ErroDeServicoDoUsuarioEmailInvalido
	ErroDeServicoDoUsuarioFalhaNaBusca
	ErroDeServicoDoUsuarioUsuarioInexistente
)

func erroDoBancoParaErroDeServicoDoUsuario(erro banco.ErroBancoUsuario) ErroDeServicoDoUsuario {
	switch erro {
	case banco.ErroLoginDuplicado:
		return ErroDeServicoDoUsuarioLoginDuplicado
	case banco.ErroCpfDuplicado:
		return ErroDeServicoDoUsuarioCpfDuplicado
	case banco.ErroEmailDuplicado:
		return ErroDeServicoDoUsuarioEmailDuplicado
	default:
		return ErroDeServicoDoUsuarioNenhum
	}
}

// Para criar o usuário é preciso forncer todos os dados do novoUsuario
// mas do usuario criador só precisamos fornecer o sessão

func CriarUsuario(idDaSessao uint64, loginUsuarioCriador string, novoUsuario modelos.Usuario) ErroDeServicoDoUsuario {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginUsuarioCriador) != sessao.VALIDO {
		return ErroDeServicoDoUsuarioSessaoInvalida
	}

	permissaoDoUsuarioCriador := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuarioCriador&utilidades.PermissaoCriarUsuario != utilidades.PermissaoCriarUsuario {
		return ErroDeServicoDoUsuarioSemPermisao
	}

	if len(novoUsuario.Cpf) > 0 && (!utilidades.StringENumerica(novoUsuario.Cpf) || !utilidades.ValidarCpf(novoUsuario.Cpf)) {
		return ErroDeServicoDoUsuarioCpfInvalido
	}

	if len(novoUsuario.Telefone) > 0 && (!utilidades.StringENumerica(novoUsuario.Telefone) || len(novoUsuario.Telefone) != 11) {
		return ErroDeServicoDoUsuarioTelefoneInvalido
	}

	if _, erro := time.Parse(time.DateOnly, novoUsuario.DataDeNascimento); len(novoUsuario.DataDeNascimento) > 0 && erro != nil {
		return ErroDeServicoDoUsuarioDataDeNascimentoInvalida
	}

	if !utilidades.ValidarEmail(novoUsuario.Email) {
		return ErroDeServicoDoUsuarioEmailInvalido
	}

	return erroDoBancoParaErroDeServicoDoUsuario(banco.CriarUsuario(novoUsuario))

}

func BuscarUsuarios(idDaSessao uint64, loginDoUsuarioBuscador string, textoDaBusca string) ([]modelos.Usuario, ErroDeServicoDoUsuario) {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioBuscador) != sessao.VALIDO {
		return nil, ErroDeServicoDoUsuarioSessaoInvalida
	}

	permissaoDoUsuarioBuscador := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if textoDaBusca == "" {
		println(loginDoUsuarioBuscador)
		usuarioBuscador, erro := banco.PesquisarUsuarioPeloLogin(loginDoUsuarioBuscador)
		if erro {
			return []modelos.Usuario{}, ErroDeServicoDoUsuarioNenhum
		}
		return []modelos.Usuario{usuarioBuscador}, ErroDeServicoDoUsuarioNenhum
	}

	if permissaoDoUsuarioBuscador&utilidades.PermssaoLerUsuario != utilidades.PermssaoLerUsuario {
		return nil, ErroDeServicoDoUsuarioSemPermisao
	}

	usuarioEncontrados := banco.PesquisarUsuario(textoDaBusca)

	return usuarioEncontrados, ErroDeServicoDoUsuarioNenhum
}

func AtualizarUsuario(idDaSessao uint64, loginDoUsuarioRequerente string, usuarioComDadosAtualizados modelos.Usuario) (modelos.Usuario, ErroDeServicoDoUsuario) {

	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioRequerente) != sessao.VALIDO {
		return usuarioComDadosAtualizados, ErroDeServicoDoUsuarioSessaoInvalida
	}

	permissaoDoUsuarioRequerente := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	usuarioComDadosAntigos, achou := banco.PegarUsuarioPeloId(usuarioComDadosAtualizados.IdDoUsuario)
	if !achou {
		return usuarioComDadosAtualizados, ErroDeServicoDoUsuarioUsuarioInexistente
	}

	usuarioMudaASiMesmo := PegarIdUsuario(loginDoUsuarioRequerente) == usuarioComDadosAntigos.IdDoUsuario

	// Um usuário está tentando mudar a senha de outro. Isso é proibido
	if !usuarioMudaASiMesmo && usuarioComDadosAtualizados.Senha != "" {
		return usuarioComDadosAtualizados, ErroDeServicoDoUsuarioSemPermisao
	}

	if !usuarioMudaASiMesmo && permissaoDoUsuarioRequerente&utilidades.PermissaoAtualizarUsuario != utilidades.PermissaoAtualizarUsuario {
		return usuarioComDadosAtualizados, ErroDeServicoDoUsuarioSemPermisao
	}

	if len(usuarioComDadosAtualizados.Cpf) > 0 && (!utilidades.StringENumerica(usuarioComDadosAtualizados.Cpf) || !utilidades.ValidarCpf(usuarioComDadosAtualizados.Cpf)) {
		return usuarioComDadosAtualizados, ErroDeServicoDoUsuarioCpfInvalido
	}

	if len(usuarioComDadosAtualizados.Telefone) > 0 && (!utilidades.StringENumerica(usuarioComDadosAtualizados.Telefone) || len(usuarioComDadosAtualizados.Telefone) != 11) {
		return usuarioComDadosAtualizados, ErroDeServicoDoUsuarioTelefoneInvalido
	}

	if _, erro := time.Parse(time.DateOnly, usuarioComDadosAtualizados.DataDeNascimento); len(usuarioComDadosAtualizados.DataDeNascimento) > 0 && erro != nil {
		return usuarioComDadosAtualizados, ErroDeServicoDoUsuarioDataDeNascimentoInvalida
	}

	if !utilidades.ValidarEmail(usuarioComDadosAtualizados.Email) {
		return usuarioComDadosAtualizados, ErroDeServicoDoUsuarioEmailInvalido
	}

	return usuarioComDadosAtualizados, erroDoBancoParaErroDeServicoDoUsuario(banco.AtualizarUsuario(usuarioComDadosAntigos, usuarioComDadosAtualizados))
}

func PegarUsuarioPeloId(id int) (modelos.Usuario, bool) {
	return banco.PegarUsuarioPeloId(id)
}

func DeletarUsuario(idDaSessao uint64, loginDoUsuarioRequerente string, idDoUsuarioQueDesejaExcluir int) ErroDeServicoDoUsuario {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioRequerente) != sessao.VALIDO {
		return ErroDeServicoDoUsuarioSessaoInvalida
	}

	permissaoDoUsuarioRequerente := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuarioRequerente&utilidades.PermissaoDeletarUsuario != utilidades.PermissaoDeletarUsuario {
		return ErroDeServicoDoUsuarioSemPermisao
	}

	fmt.Println(idDoUsuarioQueDesejaExcluir)

	return erroDoBancoParaErroDeServicoDoUsuario(banco.ExcluirUsuario(idDoUsuarioQueDesejaExcluir))
}

func PegarIdUsuario(login string) int {
	return banco.PegarIdUsuario(login)
}

func PegarPermissao(login string) uint64 {
	return banco.PegarPermissao(login)
}
