package usuario

import (
	"biblioteca/banco"
	"biblioteca/modelos"
	"biblioteca/servicos/sessao"
	"biblioteca/utilidades"
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
)

func erroDeCadastroDoUsuarioDoBancoParaErroDeServicoDoUsuario(erro banco.ErroDeCadastroDoUsuario) ErroDeServicoDoUsuario {
	switch erro {
	case banco.ErroDeCadastroDoUsuarioLoginDuplicado:
		return ErroDeServicoDoUsuarioLoginDuplicado
	case banco.ErroDeCadastroDoUsuarioCpfDuplicado:
		return ErroDeServicoDoUsuarioCpfDuplicado
	case banco.ErroDeCadastroDoUsuarioErroDesconhecido:
		return ErroDeServicoDoUsuarioErroDesconhecido
	case banco.ErroDeCadastroDoUsuarioEmailDuplicado:
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

	if !utilidades.StringENumerica(novoUsuario.Cpf) || !utilidades.ValidarCpf(novoUsuario.Cpf) {
		return ErroDeServicoDoUsuarioCpfInvalido
	}

	if !utilidades.StringENumerica(novoUsuario.Telefone) || len(novoUsuario.Telefone) != 11 {
		return ErroDeServicoDoUsuarioTelefoneInvalido
	}

	if _, erro := time.Parse(time.DateOnly, novoUsuario.DataDeNascimento); erro != nil {
		return ErroDeServicoDoUsuarioDataDeNascimentoInvalida
	}

	if !utilidades.ValidarEmail(novoUsuario.Email) {
		return ErroDeServicoDoUsuarioEmailInvalido
	}

	return erroDeCadastroDoUsuarioDoBancoParaErroDeServicoDoUsuario(banco.CriarUsuario(novoUsuario))

}

func BuscarUsuarios(idDaSessao uint64, loginDoUsuarioBuscador string, textoDaBusca string) ([]modelos.Usuario, ErroDeServicoDoUsuario){
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuarioBuscador) != sessao.VALIDO {
		return nil, ErroDeServicoDoUsuarioSessaoInvalida
	}

	permissaoDoUsuarioBuscador := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if(textoDaBusca == "") {
		usuarioBuscador, erro := banco.PesquisarUsuarioPeloLogin(loginDoUsuarioBuscador)
		if erro == banco.ErroDeBuscaDeUsuarioFalhaNaBusca {
			return nil, ErroDeServicoDoUsuarioFalhaNaBusca
		}
		return []modelos.Usuario{usuarioBuscador}, ErroDeServicoDoUsuarioNenhum
	}


	if permissaoDoUsuarioBuscador&utilidades.PermssaoLerUsuario != utilidades.PermssaoLerUsuario {
		return nil, ErroDeServicoDoUsuarioSemPermisao
	}

	usuarioEncontrados, erro := banco.PesquisarUsuario(textoDaBusca)
	if erro == banco.ErroDeBuscaDeUsuarioFalhaNaBusca {
		return nil, ErroDeServicoDoUsuarioFalhaNaBusca
	}
	return usuarioEncontrados, ErroDeServicoDoUsuarioNenhum
}


func PegarIdUsuario(login string) int {
	return banco.PegarIdUsuario(login)
}

func PegarPermissao(login string) uint64 {
	return banco.PegarPermissao(login)
}
