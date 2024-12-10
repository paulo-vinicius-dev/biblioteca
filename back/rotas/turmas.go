package rotas

import (
	"biblioteca/modelos"
	"biblioteca/servicos"
	"encoding/json"
	"fmt"
	"net/http"
)

type RepostaTurmas struct {
	Turmas []modelos.Turma
}

func Turma(resposta http.ResponseWriter, requisicao *http.Request) {
	respotaTurmaJson, _ := json.Marshal(&RepostaTurmas{
		Turmas: servicos.PegarTodasAsTurmas(),
	})

	if requisicao.Method != "GET" {
		resposta.WriteHeader(http.StatusMethodNotAllowed)
		fmt.Fprintf(resposta, "Apenas o método GET é suportado nessa rota")
		return
	}

	fmt.Fprintf(resposta, "%s", respotaTurmaJson)
}
