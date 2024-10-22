package banco

import (
	//"log"
	"biblioteca/modelos"
	"context"
	"crypto/sha256"
	"fmt"
)

type ErroDeCadastroDoUsuario int

// Erros
const (
	ErroDeCadastroDoUsuarioNenhum = iota
	ErroDeCadastroDoUsuarioLoginDuplicado
	ErroDeCadastroDoUsuarioCpfDuplicado
	ErroDeCadastroDoUsuarioEmailDuplicado
	ErroDeCadastroDoUsuarioErroDesconhecido
)

func CriarUsuario(novoUsuario modelos.Usuario) ErroDeCadastroDoUsuario {
	conexao := PegarConexao()
	hash := sha256.New()
	hash.Write([]byte(novoUsuario.Senha))

	if emailDuplicado, erro := emailDuplicado(novoUsuario.Email); erro {
		return ErroDeCadastroDoUsuarioErroDesconhecido
	} else if emailDuplicado {
		return ErroDeCadastroDoUsuarioEmailDuplicado
	}

	if loginDuplicado, erro := loginDuplicado(novoUsuario.Login); erro {
		return ErroDeCadastroDoUsuarioErroDesconhecido
	} else if loginDuplicado {
		return ErroDeCadastroDoUsuarioLoginDuplicado
	}

	if cpfDuplicado, erro := cpfDuplicado(novoUsuario.Cpf); erro {
		return ErroDeCadastroDoUsuarioErroDesconhecido
	} else if cpfDuplicado {
		return ErroDeCadastroDoUsuarioCpfDuplicado
	}

	senhaCriptogrfada := fmt.Sprintf("%x", hash.Sum(nil))
	_, erroQuery := conexao.Exec(
		context.Background(),
		"insert into usuario(login,cpf, nome, email, telefone, data_nascimento, data_criacao, senha, permissoes) values ($1, $2, $3, $4, $5, $6, CURRENT_DATE, $7, $8)",
		novoUsuario.Login,
		novoUsuario.Cpf,
		novoUsuario.Nome,
		novoUsuario.Email,
		novoUsuario.Telefone,
		novoUsuario.DataDeNascimento,
		senhaCriptogrfada,
		novoUsuario.Permissao,
	)

	if erroQuery != nil {
		return ErroDeCadastroDoUsuarioErroDesconhecido
	}

	return ErroDeCadastroDoUsuarioNenhum
}

func PegarPermissao(loginDoUsuario string) uint64 {
	conexao := PegarConexao()
	var permissao uint64
	if conexao.QueryRow(context.Background(), "select permissoes from usuario where login = $1", loginDoUsuario).Scan(&permissao) == nil {
		return permissao
	} else {
		return 0
	}
}

func cpfDuplicado(cpf string) (bool, bool) {
	conexao := PegarConexao()
	qtdCpfs := 0
	if conexao.QueryRow(context.Background(), "select count(cpf) from usuario u where cpf = $1", cpf).Scan(&qtdCpfs) == nil {
		return qtdCpfs > 0, false
	} else {
		return false, true
	}
}

func emailDuplicado(email string) (bool, bool) {
	conexao := PegarConexao()
	qtdEmail := 0
	if conexao.QueryRow(context.Background(), "select count(email) from usuario u where email = $1", email).Scan(&qtdEmail) == nil {
		return qtdEmail > 0, false
	} else {
		return false, true
	}
}

func loginDuplicado(login string) (bool, bool) {
	conexao := PegarConexao()
	qtdLogin := 0
	if conexao.QueryRow(context.Background(), "select count(login) from usuario u where login = $1", login).Scan(&qtdLogin) == nil {
		return qtdLogin > 0, false
	} else {
		return false, true
	}
}
