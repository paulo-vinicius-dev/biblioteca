package banco

import (
	//"log"
	"biblioteca/modelos"
	"context"
	"crypto/sha256"
	"fmt"
	pgx "github.com/jackc/pgx/v5"

)

type ErroDeCadastroDoUsuario int

type ErroDeBuscaDeUsuario int

// Erros no cadastro do usuário
const (
	ErroDeCadastroDoUsuarioNenhum = iota
	ErroDeCadastroDoUsuarioLoginDuplicado
	ErroDeCadastroDoUsuarioCpfDuplicado
	ErroDeCadastroDoUsuarioEmailDuplicado
	ErroDeCadastroDoUsuarioErroDesconhecido
)

// Erros na busca do usuário
const (
	ErroDeBuscaDeUsuarioFalhaNaBusca = iota
	ErroDeBuscaDeUsuarioNenhum
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

func PesquisarUsuario(busca string) ([]modelos.Usuario,ErroDeBuscaDeUsuario)  {
	conexao := PegarConexao()
	busca = "%" + busca + "%" // isso está sujeitio a sql injection por favor olhar depois
	textoQuery := "select id_usuario, login, cpf, nome, email, telefone, to_char(data_nascimento, 'yyyy-mm-dd'), permissoes from usuario where login like $1 or nome like $1 or email like $1 or cpf like $1"
	linhas, erro := conexao.Query(context.Background(), textoQuery, busca)
	if erro != nil {
		return nil, ErroDeBuscaDeUsuarioFalhaNaBusca
	}
	var usuarioTemporario modelos.Usuario
	usuariosEncontrados := make([]modelos.Usuario, 0)
	_, erro = pgx.ForEachRow(linhas,[]any{&usuarioTemporario.IdDoUsuario,&usuarioTemporario.Login,&usuarioTemporario.Cpf,&usuarioTemporario.Nome,&usuarioTemporario.Email,&usuarioTemporario.Telefone,&usuarioTemporario.DataDeNascimento,&usuarioTemporario.Permissao}, func () error {
		usuariosEncontrados = append(usuariosEncontrados, usuarioTemporario)
		return nil
	})
	if erro != nil {
		return nil, ErroDeBuscaDeUsuarioFalhaNaBusca
	}
	return usuariosEncontrados, ErroDeBuscaDeUsuarioNenhum
}

func PesquisarUsuarioPeloLogin(login string) (modelos.Usuario, ErroDeBuscaDeUsuario) {
	conexao := PegarConexao()
	var usuario modelos.Usuario
	textoQuery := "select id_usuario, login, cpf, nome, email, telefone, to_char(data_nascimento, 'yyyy-mm-dd'), permissoes from usuario where login = $1"
	if erro := conexao.QueryRow(context.Background(), textoQuery,  login).Scan(
		&usuario.IdDoUsuario,
		&usuario.Login,
		&usuario.Cpf,
		&usuario.Nome,
		&usuario.Email,
		&usuario.Telefone,
		&usuario.DataDeNascimento,
		&usuario.Permissao); erro == nil {
		return usuario, ErroDeBuscaDeUsuarioNenhum
	} else {
		return usuario, ErroDeBuscaDeUsuarioFalhaNaBusca
	}
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

func PegarIdUsuario(login string) int {
	conexao := PegarConexao()
	var id int
	if conexao.QueryRow(context.Background(), "select id_usuario from usuario where login = $1",  login).Scan(&id) == nil {
		return id
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
