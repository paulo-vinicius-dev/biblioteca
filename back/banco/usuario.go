package banco

import (
	//"log"
	"biblioteca/modelos"
	"context"
	"crypto/sha256"
	"fmt"
	"strings"
)

type ErroDeCadastroDoUsuario int

// Erros
const (
	ErroDeCadastroDoUsuarioNenhum = iota
	ErroDeCadastroDoUsuarioLoginDuplicado
	ErroDeCadastroDoUsuarioCpfDuplicado
	ErroDeCadastroDoUsuarioErroDesconhecido
)

func CriarUsuario(novoUsuario modelos.Usuario) ErroDeCadastroDoUsuario {
	conexao := PegarConexao()
	hash := sha256.New()
	hash.Write([]byte(novoUsuario.Senha))

	senhaCriptogrfada := fmt.Sprintf("%x", hash.Sum(nil))
	resultadoDoBanco, erro := conexao.Exec(
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

	if erro != nil {
		stringDoErro := resultadoDoBanco.String()
		switch {
		case strings.Contains(stringDoErro, "login"):
			return ErroDeCadastroDoUsuarioLoginDuplicado
		case strings.Contains(stringDoErro, "cpf"):
			return ErroDeCadastroDoUsuarioCpfDuplicado
		default:
			fmt.Println(stringDoErro)
			return ErroDeCadastroDoUsuarioErroDesconhecido
		}

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
