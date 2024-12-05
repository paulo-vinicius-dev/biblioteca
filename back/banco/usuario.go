package banco

import (
	//"log"
	"biblioteca/modelos"
	"context"
	"crypto/sha256"
	"fmt"
	pgx "github.com/jackc/pgx/v5"

)

type ErroBancoUsuario int

func CriptografarSenha(senha string) string {
	hash := sha256.New()
	hash.Write([]byte(senha))
	return fmt.Sprintf("%x", hash.Sum(nil))
}


func CriarUsuario(novoUsuario modelos.Usuario) ErroBancoUsuario {
	conexao := PegarConexao()

	if EmailDuplicado(novoUsuario.Email) {
		return ErroEmailDuplicado
	}

	if LoginDuplicado(novoUsuario.Login) {
		return ErroLoginDuplicado
	}

	if CpfDuplicado(novoUsuario.Cpf) {
		return ErroCpfDuplicado
	}

	senhaCriptogrfada := CriptografarSenha(novoUsuario.Senha)
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
		fmt.Println(erroQuery)
		panic("Um erro imprevisto acontesceu no cadastro do usuário. Provavelmente é um bug")
	}

	return ErroNenhum
}

func AtualizarUsuario(usuarioComDadosAntigos,usuarioAtualizado modelos.Usuario) ErroBancoUsuario {

	if usuarioComDadosAntigos.Login != usuarioAtualizado.Login && LoginDuplicado(usuarioAtualizado.Login){
		return ErroLoginDuplicado
	}

	if usuarioComDadosAntigos.Cpf != usuarioAtualizado.Cpf && CpfDuplicado(usuarioAtualizado.Cpf){
		return ErroCpfDuplicado
	}

	if usuarioComDadosAntigos.Email != usuarioAtualizado.Email && CpfDuplicado(usuarioAtualizado.Email){
		return ErroEmailDuplicado
	}

	conexao := PegarConexao()
	textoQuery := "update usuario set login = $1, cpf = $2, nome = $3, email = $4, telefone = $5, data_nascimento = $6, data_atualizacao = CURRENT_DATE, permissoes = $7, ativo = $8 where id_usuario = $9"
	if _, erroQuery  := conexao.Query(
		context.Background(),
		textoQuery,
	        usuarioAtualizado.Login,
	        usuarioAtualizado.Cpf,
	        usuarioAtualizado.Nome,
	        usuarioAtualizado.Email,
		usuarioAtualizado.Telefone,
		usuarioAtualizado.DataDeNascimento,
	        usuarioAtualizado.Permissao,
		usuarioAtualizado.Ativo,
	        usuarioAtualizado.IdDoUsuario,
	); erroQuery != nil {
		panic("Um erro desconhecido acontesceu na atualização do usuário")
	}

	if usuarioAtualizado.Senha != "" {
		senhaCriptogrfada := CriptografarSenha(usuarioAtualizado.Senha)
		textoQuery := "update usuario set senha = $1 where id_usuario = $2"
		if _, erroQuery := conexao.Query(context.Background(), textoQuery, senhaCriptogrfada, usuarioAtualizado.IdDoUsuario); erroQuery != nil {
			panic("Um erro desconhecido acontesceu na atualização do usuário")
		}
	}

	return ErroNenhum
}

func ExcluirUsuario(idDoUsuario int) ErroBancoUsuario{
	usuario, achou := PegarUsuarioPeloId(idDoUsuario)
	if !achou {
		return ErroUsuarioInexistente
	}
	usuarioCopia := usuario
	usuario.Ativo = false
	return AtualizarUsuario(usuarioCopia, usuario)
}


func PesquisarUsuario(busca string) []modelos.Usuario  {
	conexao := PegarConexao()
	busca = "%" + busca + "%" // isso está sujeitio a sql injection por favor olhar depois
	textoQuery := "select id_usuario, login, cpf, nome, email, telefone, to_char(data_nascimento, 'yyyy-mm-dd'), permissoes, ativo from usuario where login like $1 or nome like $1 or email like $1 or cpf like $1"
	linhas, erro := conexao.Query(context.Background(), textoQuery, busca)
	if erro != nil {
		return []modelos.Usuario{}
	}
	var usuarioTemporario modelos.Usuario
	usuariosEncontrados := make([]modelos.Usuario, 0)
	_, erro = pgx.ForEachRow(linhas,[]any{&usuarioTemporario.IdDoUsuario,&usuarioTemporario.Login,&usuarioTemporario.Cpf,&usuarioTemporario.Nome,&usuarioTemporario.Email,&usuarioTemporario.Telefone,&usuarioTemporario.DataDeNascimento,&usuarioTemporario.Permissao, &usuarioTemporario.Ativo}, func () error {
		usuariosEncontrados = append(usuariosEncontrados, usuarioTemporario)
		return nil
	})
	if erro != nil {
		return []modelos.Usuario{}
	}
	return usuariosEncontrados
}

func PesquisarUsuarioPeloLogin(login string) (modelos.Usuario, bool) {
	conexao := PegarConexao()
	var usuario modelos.Usuario
	textoQuery := "select id_usuario, login, cpf, nome, email, telefone, to_char(data_nascimento, 'yyyy-mm-dd'), permissoes, ativo from usuario where login = $1"
	if erro := conexao.QueryRow(context.Background(), textoQuery,  login).Scan(
		&usuario.IdDoUsuario,
		&usuario.Login,
		&usuario.Cpf,
		&usuario.Nome,
		&usuario.Email,
		&usuario.Telefone,
		&usuario.DataDeNascimento,
		&usuario.Permissao,
		&usuario.Ativo); erro == nil {
		return usuario, false
	} else {
		return usuario, true
	}
}


func PegarUsuarioPeloId(id int) (modelos.Usuario, bool) {
	conexao := PegarConexao()
	var usuario modelos.Usuario
	textoQuery := "select id_usuario, login, cpf, nome, email, telefone, to_char(data_nascimento, 'yyyy-mm-dd'), permissoes, ativo from usuario where id_usuario = $1"
	if erro := conexao.QueryRow(context.Background(), textoQuery,  id).Scan(
		&usuario.IdDoUsuario,
		&usuario.Login,
		&usuario.Cpf,
		&usuario.Nome,
		&usuario.Email,
		&usuario.Telefone,
		&usuario.DataDeNascimento,
		&usuario.Permissao,
		&usuario.Ativo); erro == nil {
			return usuario, true
		} else {
			return usuario, false
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

func CpfDuplicado(cpf string) bool {
	conexao := PegarConexao()
	qtdCpfs := 0
	if conexao.QueryRow(context.Background(), "select count(cpf) from usuario u where cpf = $1", cpf).Scan(&qtdCpfs) == nil {
		return qtdCpfs > 0
	} else {
		panic("Erro ao procurar por cpf duplicado. Provavelmente é um bug")
	}
}

func EmailDuplicado(email string) bool {
	conexao := PegarConexao()
	qtdEmail := 0
	if conexao.QueryRow(context.Background(), "select count(email) from usuario u where email = $1", email).Scan(&qtdEmail) == nil {
		return qtdEmail > 0
	} else {
		panic("Erro ao procurar por email duplicado. Provavelmente é um bug")

	}
}

func LoginDuplicado(login string) bool {
	conexao := PegarConexao()
	qtdLogin := 0
	if conexao.QueryRow(context.Background(), "select count(login) from usuario u where login = $1", login).Scan(&qtdLogin) == nil {
		return qtdLogin > 0
	} else {
		panic("Erro ao procurar por login duplicado. Provavelmente é um bug")
	}
}
