package rotas

import ( 
	"net/http"
	"fmt"
	"biblioteca/servicos/sessao"
	"io"
	"encoding/json"
	"biblioteca/banco"
	"crypto/sha256"
)


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
	status := sessao.VerificaSeIdDaSessaoEValido(requisicaoLogin.Id, requisicaoLogin.Login)

	// evita uma ida ao BD
	if (status == sessao.VALIDO) {
		return true, status
	}

	login, senha, achou := banco.PegarLoginESenhaDoBanco(requisicaoLogin.Login)		

	if(!achou) {
		return false, sessao.INVALIDO
	}

	
	hash := sha256.New()
	hash.Write([]byte(requisicaoLogin.Senha))

	shaDaSenhaDaRequisicao := fmt.Sprintf("%x", hash.Sum(nil))

	return  requisicaoLogin.Login == login && shaDaSenhaDaRequisicao == senha, status
}

func Login(resposta http.ResponseWriter, requisicao *http.Request) {
	if(requisicao.Method == "GET") {
		resposta.WriteHeader(http.StatusMethodNotAllowed)	
		fmt.Fprintf(resposta, "O login não aceita o metodo GET")
		return
	} 

	corpoDaRequisicao, erro := io.ReadAll(requisicao.Body)
	if len(corpoDaRequisicao) == 0 || erro != nil {
		resposta.WriteHeader(http.StatusBadRequest)
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
	respostaLogin.IdSessao = requisicaoLogin.Id

	//Se tentar logar com uma sessão de outro usuario vamos dar um erro
	if statusDoIdDaSessao == sessao.SESSAO_INVALIDA {
		resposta.WriteHeader(http.StatusBadRequest);
		fmt.Fprintf(resposta, "A o id da sessão fornecido não bate com a sessão do login do usuário")
		return  
	}

	//Se o login tiver invalido ou expirado criamos outra sessao
	if (statusDoIdDaSessao == sessao.INVALIDO ) && loginAceito {
		for i := 0; i < 3; i++ {
			novaSessao, criadoComSucesso := sessao.CriarNovaSessao(requisicaoLogin.Login)
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

