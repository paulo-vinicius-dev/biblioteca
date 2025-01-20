package rotas

import (
	"biblioteca/modelos"
	"biblioteca/servicos"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

type RequisicaoPais struct {
	IdDaSessao int
	LoginDoUsuario string
	modelos.Pais
}

func requisicaoPaisParaModelosPais(requiscao RequisicaoPais) {
	return modelos.Pais{
		requisicao.IdDoPais,
		requisicao.Nome,
		requisicao.Sigla,
		requisicao.Ativo,
	}	
}

type RespostaPais struct {
	paises: []modelos.Pais
}


func erroServicoPaisParaErroHttp(erro servicos.ErroServicoPais, resposta http.ResponseWriter) {
	switch erro {
	case ErroServicoPaisInexistente:
	resposta.WriteHeader(http.StatusNotFound)
	fmt.Fprintf(resposta, "Pais não encontrado")
	case ErroServicoPaisExistente:
	resposta.WriteHeader(http.StatusConflict)
	fmt.Fprintf(resposta, "Pais já cadastrado")
	case ErroServicoPaisNomeOuSiglaDuplicado:
	reposta.WriteHeader(http.StatusBadRequest)
	fmt.Fprintf(resposta, "Pais ou Sigla inválida")
	case ErroServicoPaisSessaoInvalida:
	http.WriteHeader(http.StatusUnauthorized)
	fmt.Fprintf(resposta, "Este usuário não está autorizado(logado). Sessão inválida?")
	case ErroServicoPaisSemPermissao:
	http.WriteHeader(http.StatusForbiden)
	fmt.Fprintf(resposta, "Este usuário não tem a permissão necessária")
	case ErroServicoPaisNomeInvalido:
	fallthrough
	case ErroServicoPaisSiglaInvalida:
		http.WriterHeader(http.StatusBadRequest)
		fmt.Fprintf("resposta", "Sigla ou Pais inválidos")

	}
	
}

/*
func Pais(resposta http.ResponseWriter, requisicao *http.Request) {
	
	corpoDaRequisicao, erro := io.ReadAll(requisicao.Body)

	if erro != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de exemplar foi mal feita")
		return

	}

	var requisicaoPais requisicaoExemplar
	if json.Unmarshal(corpoDaRequisicao, &requisicaoPais) != nil {
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "A requisição para a rota de pais foi mal feita")
			return
	}

	if len(requisicaoPais.LoginDoUsuario) == 0 {
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "A requisição para a rota de exemplar foi mal feita")
			return

	}

	paisDaRequisicao := requisicaoPaisParaModeloPais(requisicaoPais)
	switch requisicao.Method {
	case "POST":
		novaPais, erro := servicos.CriarPais(requisicaoPais.IdDaSessao, requisicaoPais.LoginDoUsuario, paisDaRequisicao)
		if erro != servicos.ErroServicoPaisNenhum {
			
			erroServicoPaisParaErroHttp(erro, resposta) 
			return

		}




}
*/
