package rotas

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"biblioteca/servicos/recuperarSenha"
)


type RequisicaoRecuperacaoDeSenha struct {
	EmailDoUsuario string
	Codigo string
	NovaSenha string
}

func RecuperarSenha(resposta http.ResponseWriter, requisicao *http.Request) {
	corpoDaRequisicao, erro := io.ReadAll(requisicao.Body)

	if erro != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de recuperação de senha foi mal feita")
		return
	}

	var requisicaoRecuperacaoDeSenha RequisicaoRecuperacaoDeSenha
	if json.Unmarshal(corpoDaRequisicao, &requisicaoRecuperacaoDeSenha) != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de recuperação foi mal feita")
		return
	}

	switch requisicao.Method {
		case "POST":
			if requisicaoRecuperacaoDeSenha.EmailDoUsuario == "" {
				resposta.WriteHeader(http.StatusBadRequest)
				fmt.Fprintf(resposta, "É necessário fornecer o email do usuário")
				return	
			}

			if !recuperarSenha.CriarCodigoDeRecuperacao(requisicaoRecuperacaoDeSenha.EmailDoUsuario) {
				resposta.WriteHeader(http.StatusInternalServerError)
				fmt.Fprintf(resposta, "Erro ao enviar o código para o email do usuário. Por favor tente novamente")
				return	
			}
			
			return
		case "PUT":
			if requisicaoRecuperacaoDeSenha.Codigo == "" {
				resposta.WriteHeader(http.StatusBadRequest)
				fmt.Fprintf(resposta, "É necessário fornecer o código")
				return	
			}

			if requisicaoRecuperacaoDeSenha.NovaSenha == "" {
				resposta.WriteHeader(http.StatusBadRequest)
				fmt.Fprintf(resposta, "É necessário fornecer a nova senha")
				return	
			}

			recuperarSenha.MudarSenha(requisicaoRecuperacaoDeSenha.Codigo, requisicaoRecuperacaoDeSenha.NovaSenha)
			return
		default:
			resposta.WriteHeader(http.StatusMethodNotAllowed)
			fmt.Fprintf(resposta, "Método não suportado")
			return
	}
}

