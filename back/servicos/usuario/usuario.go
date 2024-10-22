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
	ErroDeServicoDoUsuarioErroDesconhecido
	ErroDeServicoDoUsuarioTelefoneInvalido
	ErroDeServicoDoUsuarioSemPermisao
	ErroDeServicoDoUsuarioSessaoInvalida
	ErroDeServicoDoUsuarioCpfInvalido
	ErroDeServicoDoUsuarioDataDeNascimentoInvalida
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

func CriarUsuario(idDaSessao uint64, loginUsuarioCriador string, novoUsuario modelos.Usuario) ErroDeServicoDoUsuario {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginUsuarioCriador) != sessao.VALIDO {
		return ErroDeServicoDoUsuarioSessaoInvalida
	}

	permissaoDoUsuarioCriador := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissaoDoUsuarioCriador&utilidades.PermissaoCriarUsuario != utilidades.PermissaoCriarUsuario {
		return ErroDeServicoDoUsuarioSemPermisao
	}

	fmt.Println("E valido?", utilidades.ValidarCpf(novoUsuario.Cpf))
	fmt.Println("E numerico?", utilidades.ValidarCpf(novoUsuario.Cpf))

	if !utilidades.StringENumerica(novoUsuario.Cpf) && !utilidades.ValidarCpf(novoUsuario.Cpf) {
		return ErroDeServicoDoUsuarioCpfInvalido
	}

	if !utilidades.StringENumerica(novoUsuario.Telefone) && len(novoUsuario.Telefone) != 11 {
		return ErroDeServicoDoUsuarioTelefoneInvalido
	}

	if _, erro := time.Parse(time.DateOnly, novoUsuario.DataDeNascimento); erro != nil {
		return ErroDeServicoDoUsuarioDataDeNascimentoInvalida
	}

	return erroDeCadastroDoUsuarioDoBancoParaErroDeServicoDoUsuario(banco.CriarUsuario(novoUsuario))

}

func PegarPermissao(login string) uint64 {
	return banco.PegarPermissao(login)
}
