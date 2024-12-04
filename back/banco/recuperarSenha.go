package banco

import (
	"context"
	"log"
)

func AlterarSenha(emailDoUsuario, novaSenha string) {
	conexao := PegarConexao()
	novaSenhaCriptografada := CriptografarSenha(novaSenha)
	comandoSql := "update usuario u set senha = $1 where u.id_usuario = (select u2.id_usuario from usuario u2 where u2.email = $2);"
	_, erro := conexao.Exec(context.Background(), comandoSql, novaSenhaCriptografada, emailDoUsuario);
	if erro != nil {
		log.Println(erro)
	}
}

func VerificaSeEmailPertenceAoUsuario(emailDoUsuario string) bool {
	conexao := PegarConexao()
	comandoSql := "select count(id_usuario) from usuario where email = $1"
	qtdDeUsuarioComEmail := 0
	if erro := conexao.QueryRow(context.Background(), comandoSql, emailDoUsuario).Scan(&qtdDeUsuarioComEmail); erro != nil {
		log.Println(erro) // deu ruim
		return false;
	}
	return qtdDeUsuarioComEmail > 0
}