package usuario

import (
	"biblioteca/banco"
	"biblioteca/modelos"
	"biblioteca/servicos/sessao"
	"biblioteca/utilidades"
)

type ErroDeServicoDoUsuario int

const (
	ErroDeServicoDoUsuarioNenhum = iota
	ErroDeServicoDoUsuarioLoginDuplicado
	ErroDeServicoDoUsuarioCpfDuplicado
	ErroDeServicoDoUsuarioErroDesconhecido
	ErroDeServicoDoUsuarioTelefoneInvalido
	ErroDeServicoDoUsuarioSemPermisao
	ErroDeServicoDoUsuarioSessaoInvalida
)

func erroDeCadastroDoUsuarioDoBancoParaErroDeServicoDoUsuario(erro banco.ErroDeCadastroDoUsuario) ErroDeServicoDoUsuario {
	switch erro {
	case banco.ErroDeCadastroDoUsuarioLoginDuplicado:
		return ErroDeServicoDoUsuarioLoginDuplicado
	case banco.ErroDeCadastroDoUsuarioCpfDuplicado:
		return ErroDeServicoDoUsuarioCpfDuplicado
	case banco.ErroDeCadastroDoUsuarioErroDesconhecido:
		return ErroDeServicoDoUsuarioErroDesconhecido
	default:
		return ErroDeServicoDoUsuarioNenhum
	}
}

// Para criar o usuário é preciso forncer todos os dados do novoUsuario
// mas do usuario criador só precisamos fornecer o sessão

func CriarUsuario(idDaSessao uint64, usuarioCriador, novoUsuario modelos.Usuario) ErroDeServicoDoUsuario {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, usuarioCriador.Login) != sessao.VALIDO {
		return ErroDeServicoDoUsuarioSessaoInvalida
	}

	if usuarioCriador.Permissao&utilidades.PermissaoCriarUsuario != utilidades.PermissaoCriarUsuario {
		return ErroDeServicoDoUsuarioSemPermisao
	}

	// Falta Validar cpf e telefone

	return erroDeCadastroDoUsuarioDoBancoParaErroDeServicoDoUsuario(banco.CriarUsuario(novoUsuario))

}
