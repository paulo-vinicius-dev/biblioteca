package rotas

import (
	"biblioteca/modelos"
	"biblioteca/servicos"
	"encoding/json"
	"fmt"
	"net/http"
)

type ViewTurma struct {
	Turma     int
	Descricao string
	Serie     int
	Turno     int
}

func modelosTurmaParaViewTurma(turmas ...modelos.Turma) []ViewTurma {
	views := make([]ViewTurma, 0, len(turmas))
	for i, t := range turmas {
		views = append(views, ViewTurma{
			Turma:     t.IdTurma,
			Descricao: fmt.Sprintf("%s %s %s", t.Serie.Descricao, t.Descricao, t.Turno.Descricao),
			Serie:     t.Serie.IdSerie,
			Turno:     t.Turno.IdTurno,
		})
		if t.IdTurma == 0 {
			views[i].Descricao = ""
		}
	}
	return views
}

type RepostaTurmas struct {
	Turmas []ViewTurma
}

func Turma(resposta http.ResponseWriter, requisicao *http.Request) {
	respotaTurmaJson, _ := json.Marshal(&RepostaTurmas{
		Turmas: modelosTurmaParaViewTurma(servicos.PegarTodasAsTurmas()...),
	})

	if requisicao.Method != "GET" {
		resposta.WriteHeader(http.StatusMethodNotAllowed)
		fmt.Fprintf(resposta, "Apenas o método GET é suportado nessa rota")
		return
	}

	fmt.Fprintf(resposta, "%s", respotaTurmaJson)
}
