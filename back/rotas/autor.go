package rotas

import (
	"biblioteca/modelos"
	"biblioteca/servicos"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

// AutorHandler gerencia a rota de autor
func AutorHandler(resposta http.ResponseWriter, requisicao *http.Request) {

	body, err := io.ReadAll(requisicao.Body)
	if err != nil {
		http.Error(resposta, "Erro ao ler o corpo da requisição", http.StatusBadRequest)
		return
	}

	var autor modelos.Autor
	err = json.Unmarshal(body, &autor)
	if err != nil {
		http.Error(resposta, "Erro ao processar JSON", http.StatusBadRequest)
		return
	}

	switch requisicao.Method {
	case http.MethodGet:
	case http.MethodPost:
		httpCode, err := servicos.ValidarCriacaoAutor(autor)
		if err != nil {
			http.Error(resposta, fmt.Sprintf("Erro: %v", err), httpCode)
			return
		}
		resposta.WriteHeader(httpCode)
		fmt.Fprint(resposta, "Autor inserido com sucesso")
	case http.MethodPut:
		httpCode, err := servicos.ValidarAtualizacaoAutor(autor)
		if err != nil {
			http.Error(resposta, fmt.Sprintf("Erro: %v", err), httpCode)
			return
		}
		resposta.WriteHeader(httpCode)
		fmt.Fprint(resposta, "Autor atualizado com sucesso")
	case http.MethodDelete:
		httpCode, err := servicos.ValidarExcluicaoAutor(autor)
		if err != nil {
			http.Error(resposta, fmt.Sprintf("Erro: %v", err), httpCode)
			return
		}
		resposta.WriteHeader(httpCode)
		fmt.Fprint(resposta, "Autor Excluído com sucesso")
	default:
		http.Error(resposta, "Erro metódo não permitido", http.StatusMethodNotAllowed)
	}
}
