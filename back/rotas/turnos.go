package rotas

import (
	"biblioteca/modelos"
	"biblioteca/servicos"
	"encoding/json"
	"fmt"
	"net/http"
)

type RepostaTurno struct {
	Turnos []modelos.Turno
}

func Turnos(resposta http.ResponseWriter, requisicao *http.Request) {
	respostaTurnoJson, _ := json.Marshal(&RepostaTurno{
		Turnos: servicos.PegarTodosOsTurnos(),
	})

	if requisicao.Method != "GET" {
		resposta.WriteHeader(http.StatusMethodNotAllowed)
		fmt.Fprintf(resposta, "Apenas o método GET é suportado nessa rota")
		return
	}

	fmt.Fprintf(resposta, "%s", respostaTurnoJson)
}
