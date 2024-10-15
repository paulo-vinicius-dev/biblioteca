package login

import	(
	"biblioteca/banco"
	"context"
	"log"
	"database/sql"
)

func PegarLoginESenhaDoBanco(loginDoUsuario string) (string, string, bool){
	conexao := banco.PegarConexao()
	var login, senha string
	erro := conexao.QueryRow(context.Background(),"select login, senha from usuario where login = $1", loginDoUsuario).Scan(&login, &senha)
	
	if erro == nil {
		return login, senha, true
	}

	switch erro {
		case sql.ErrNoRows:
			return login, senha, false
		default:
			log.Fatal(erro)
			//log.Fatalf("Erro no sql: \"select login, senha from usuario where login = '%s'\"", loginDoUsuario)
			return login, senha, false
	}

}
