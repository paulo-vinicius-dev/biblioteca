package rotas

import (
	"biblioteca/servicos"
	"encoding/json"
	"fmt"
	"net/http"
)


func Dashboard(resposta http.ResponseWriter, requisicao *http.Request) {
	if requisicao.Method != "GET" {
		resposta.WriteHeader(http.StatusMethodNotAllowed)
		return
	}

	dash := servicos.PegarDashboard()

	dashJson, _ := json.Marshal(dash)

	fmt.Fprintf(resposta, "%s", dashJson)
}
