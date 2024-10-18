package banco

import (
	//"log"
	"context"
	"biblioteca/modelos"
	"strings"
	"fmt"
	"crypto/sha256"
)

type ErroDeCadastroDoUsuario int 


//Erros
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
	diaNascimento, mesNascimento, anoNascimento := novoUsuario.DataDeNascimento.Day(), novoUsuario.DataDeNascimento.Month(), novoUsuario.DataDeNascimento.Year()
	

	senhaCriptogrfada := fmt.Sprintf("%x", hash.Sum(nil))
	resultadoDoBanco, erro := conexao.Exec(
		context.Background(),
		"insert into usuario(login, nome, email, telefone, data_nascimento, senha, permissoes) ($1, $2, $3, $4, $5, $6, $7)",
		novoUsuario.Login,
		novoUsuario.Nome,
		novoUsuario.Email,
		novoUsuario.Telefone,
		fmt.Sprintf("%d-%d-%d", diaNascimento, mesNascimento, anoNascimento),
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
				return ErroDeCadastroDoUsuarioErroDesconhecido
		}

	}

	return ErroDeCadastroDoUsuarioNenhum
}