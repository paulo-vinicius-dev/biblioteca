package banco

import	(
	"context"
)

func PegarLoginESenhaDoBanco(loginDoUsuario string) (string, string, bool){
	conexao := PegarConexao()
	var login, senha string
	erro := conexao.QueryRow(context.Background(), "select login, senha from usuario where login = $1 and ativo = true", loginDoUsuario).Scan(&login, &senha)

	if erro == nil {
		return login, senha, true
	}

	if ErroSemLinhasRetornadas(erro) {
		return login, senha, false
	}

	panic("Erro inesperado no login. Provelmente é um bug!")

}
