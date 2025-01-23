package rotas

import (
	"biblioteca/servicos"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

func Devolucao(resposta http.ResponseWriter, requisicao *http.Request) {
	corpoDaRequisicao, erro := io.ReadAll(requisicao.Body)

	if erro != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de exemplar foi mal feita")
		return
	}

	var requisicaoExemplar requisicaoExemplar
	if json.Unmarshal(corpoDaRequisicao, &requisicaoExemplar) != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de devolução foi mal feita")
		return
	}

	if len(requisicaoExemplar.LoginDoUsuario) == 0 {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de devolução foi mal feita")
		return

	}

	switch requisicao.Method {
	case "PUT":
		exemplarModificado, erro := servicos.AtualizarExemplar(requisicaoExemplar.IdDaSessao, requisicaoExemplar.LoginDoUsuario, requisicaoExemplarParaModeloExemplar(requisicaoExemplar))

		if erro != servicos.ErroServicoExemplarNenhum {
			erroServicoExemplarParaErroHttp(erro, resposta)
			return
		}

		respostaExemplar := respostaExemplar{
			Exemplares: modelosExemplarLivroParaViewExemplarLivro(exemplarModificado),
		}
		respostaExemplarJson, _ := json.Marshal(&respostaExemplar)
		fmt.Fprintf(resposta, "%s", respostaExemplarJson)
		return
	}

}
