package rotas

import (
	"biblioteca/modelos"
	"biblioteca/servicos"
	"encoding/json"
	"fmt"
	"net/http"
	"io"
)

type requisicaoTurma struct {
	Descricao string
	IdSerie int
	IdTurno int
}

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

	corpoDaRequisicao, erro := io.ReadAll(requisicao.Body)

	if erro != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de turma foi mal feita")
		return
	}

	switch requisicao.Method {
		case "GET":
			respotaTurmaJson, _ := json.Marshal(&RepostaTurmas{
				Turmas: modelosTurmaParaViewTurma(servicos.PegarTodasAsTurmas()...),
			})
			fmt.Fprintf(resposta, "%s", respotaTurmaJson)
		case "POST":
			var requisicaoTurma requisicaoTurma
			if json.Unmarshal(corpoDaRequisicao, &requisicaoTurma) != nil {
				resposta.WriteHeader(http.StatusBadRequest)
				fmt.Fprintf(resposta, "A requisição para a rota de turma foi mal feita")
				return
			}

			turma, deu_certo := servicos.CriarTurma(modelos.Turma{
				Descricao: requisicaoTurma.Descricao,
				Serie: modelos.Serie{IdSerie: requisicaoTurma.IdSerie},
				Turno: modelos.Turno{IdTurno: requisicaoTurma.IdTurno},
			})

			if !deu_certo {
				resposta.WriteHeader(http.StatusBadRequest)
				fmt.Fprintf(resposta, "A requisição para a rota de turma foi mal feita")
				return
			}

			respotaTurmaJson, _ := json.Marshal(&RepostaTurmas{
				Turmas: modelosTurmaParaViewTurma(turma),
			})
			fmt.Fprintf(resposta, "%s", respotaTurmaJson)

	}




}
