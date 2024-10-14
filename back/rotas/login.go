package rotas

import "net/http"
import "fmt"
import "biblioteca/sessao"
import "io"
import "encoding/json"


// isso definitivamente não deveria estar aqui é só um hack temporário para avançar mais rápido
type RequisicaoLogin struct {
	Id uint64
	Login string
	Senha string
}

// mesmo caso da struct acima
type RespostaLogin struct {
	IdSessao uint64
	Aceito bool
}

// isso também não deveria estar aqui
func ValidarLogin(requisicaoLogin RequisicaoLogin) (bool, int) {
	status := sessao.VerificaSeIdDaSessaoEValido(requisicaoLogin.Id)
	return  status == sessao.VALIDO || (requisicaoLogin.Login == "admin" && requisicaoLogin.Senha == "123"), status
}

func Login(resposta http.ResponseWriter, requisicao *http.Request) {
	if(requisicao.Method == "GET") {
		resposta.WriteHeader(http.StatusMethodNotAllowed)	
		fmt.Fprintf(resposta, "O login não aceita o metodo GET")
		return
	} 

	corpoDaRequisicao, erro := io.ReadAll(requisicao.Body)
	if len(corpoDaRequisicao) == 0 || erro != nil {
		resposta.WriteHeader(http.StatusBadRequest);
		fmt.Fprintf(resposta, "A requisição ao login foi mal feita")
		return 
	}

	var requisicaoLogin RequisicaoLogin
	if json.Unmarshal(corpoDaRequisicao, &requisicaoLogin) != nil {
		resposta.WriteHeader(http.StatusBadRequest);
		fmt.Fprintf(resposta, "A requisição ao login foi mal feita")
		return 
	}
	
    loginAceito, statusDoIdDaSessao := ValidarLogin(requisicaoLogin)	


	var respostaLogin RespostaLogin

	//Se o login tiver invalido ou expirado criamos outra sessao
	if statusDoIdDaSessao != sessao.VALIDO && loginAceito {
		for i := 0; i < 3; i++ {
			novaSessao, criadoComSucesso := sessao.CriarNovaSessao()
			if !criadoComSucesso {
				continue
			}
			respostaLogin.IdSessao = novaSessao
			break

		}
	}

	respostaLogin.Aceito = loginAceito
	
	stringResposta, _ := json.Marshal(respostaLogin)
	resposta.WriteHeader(http.StatusOK)
	fmt.Fprintf(resposta, "%s", string(stringResposta))

}

