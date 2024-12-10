package rotas

import (
	"biblioteca/modelos"
	"biblioteca/servicos"
	"encoding/json"
	"fmt"
	"net/http"
)

type RepostaSeries struct {
	Series []modelos.Serie
}

func Series(resposta http.ResponseWriter, requisicao *http.Request) {
	respotaSeriesJson, _ := json.Marshal(&RepostaSeries{
		Series: servicos.PegarTodasAsSeries(),
	})

	if requisicao.Method != "GET" {
		resposta.WriteHeader(http.StatusMethodNotAllowed)
		fmt.Fprintf(resposta, "Apenas o método GET é suportado nessa rota")
		return
	}

	fmt.Fprintf(resposta, "%s", respotaSeriesJson)
}
