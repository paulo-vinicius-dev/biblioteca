package rotas

import (
	"biblioteca/modelos"
	"biblioteca/servicos"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

type requisicaoSubcategoria struct {
	IdDaSessao               uint64
	LoginDoUsuarioRequerente string
	IdSubcategoria           int
	Descricao                string
	Categoria                uint64
	TextoDeBusca             string
}

type respostaSubcategoria struct {
	SubcategoriasAtingidas []modelos.Subcategoria
}

func erroServicoSubcategoriaParaErrHttp(erro servicos.ErroDeServicoDaSubcategoria, resposta http.ResponseWriter) {
	switch erro {

	case servicos.ErroDeServicoDaSubcategoriaDescricaoDuplicada:
		resposta.WriteHeader(http.StatusConflict)
		fmt.Fprintf(resposta, "A descrição informada já existe na base de dados")
		return
	case servicos.ErroDeServicoDaSubcategoriaInexistente:
		resposta.WriteHeader(http.StatusNotFound)
		fmt.Fprintf(resposta, "A subcategória requisitada não existe")
		return
	case servicos.ErroDeServicoDaSubcategoriaExcutarCriacao:
		resposta.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(resposta, "Aconteceu algum erro na ação de criação na base de dados")
		return
	case servicos.ErroDeServicoDaSubcategoriaExcutarAtualizacao:
		resposta.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(resposta, "Aconteceu algum erro na ação de atualização na base de dados")
		return
	case servicos.ErroDeServicoDaSubcategoriaExcutarExclusao:
		resposta.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(resposta, "Aconteceu algum erro na ação de exclusão na base de dados")
		return
	case servicos.ErroDeServicoDaSubcategoriaSessaoInvalida:
		resposta.WriteHeader(http.StatusUnauthorized)
		fmt.Fprintf(resposta, "Sessão inválida")
		return
	case servicos.ErroDeServicoDaSubcategoriaSemPermisao:
		resposta.WriteHeader(http.StatusUnauthorized)
		fmt.Fprintf(resposta, "Usuário não possui permissão para executar essa ação")
		return
	case servicos.ErroDeServicoDaSubcategoriaFalhaNaBusca:
		resposta.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(resposta, "Aconteceu algum erro na ação de buscar os dados de subcategoria na base de dados")
		return
	default:
		resposta.WriteHeader(http.StatusOK)
		fmt.Fprintf(resposta, "Ação realizada com sucesso")
		return
	}
}

func SubCategoria(resposta http.ResponseWriter, requisicao *http.Request) {

	corpoDaRequisicao, erro := io.ReadAll(requisicao.Body)

	if erro != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de subcategoria foi mal feita")
		return
	}

	var requisicaoSubcategoria requisicaoSubcategoria
	if json.Unmarshal(corpoDaRequisicao, &requisicaoSubcategoria) != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de subcategoria foi mal feita")
		return
	}

	if requisicaoSubcategoria.LoginDoUsuarioRequerente == "" {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de subcategoria foi mal feita")
		return
	}

	switch requisicao.Method {
	case "POST":
		if len(requisicaoSubcategoria.Descricao) < 1 {
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Algum campo necessário para o cadastro não foi fornecido")
			return
		}

		var novaSubcategoria modelos.Subcategoria
		novaSubcategoria.Descricao = requisicaoSubcategoria.Descricao

		erro := servicos.CriarSubcategoria(requisicaoSubcategoria.IdDaSessao, requisicaoSubcategoria.LoginDoUsuarioRequerente, novaSubcategoria)

		if erro != servicos.ErroDeServicoDaSubcategoriaNenhum {
			erroServicoSubcategoriaParaErrHttp(erro, resposta)
			return
		}

		novaSubcategoria.IdSubcategoria = servicos.PegarIdSubcategoria(novaSubcategoria.Descricao)

		respostaSubcategoria := respostaSubcategoria{
			[]modelos.Subcategoria{
				novaSubcategoria,
			},
		}

		respostaSubcategoriaJson, _ := json.Marshal(&respostaSubcategoria)

		fmt.Fprintf(resposta, "%s", respostaSubcategoriaJson)

		return
	case "GET":
		subcategoriasEncontradas, erro := servicos.BuscarSubcategoria(requisicaoSubcategoria.IdDaSessao, requisicaoSubcategoria.LoginDoUsuarioRequerente, requisicaoSubcategoria.TextoDeBusca)
		if erro == servicos.ErroDeServicoDaSubcategoriaSemPermisao {
			resposta.WriteHeader(http.StatusForbidden)
			fmt.Fprintf(resposta, "Este usuário não tem permissão para essa operação")
			return
		} else if erro == servicos.ErroDeServicoDaSubcategoriaFalhaNaBusca {
			resposta.WriteHeader(http.StatusInternalServerError)
			fmt.Fprint(resposta, "Houve um erro interno enquanto se fazia a busca! Provavelmente é um bug na api!")
			return
		}
		respostaSubcategoria := respostaSubcategoria{
			subcategoriasEncontradas,
		}
		respostaSubcategoriaJson, _ := json.Marshal(&respostaSubcategoria)

		fmt.Fprintf(resposta, "%s", respostaSubcategoriaJson)

	case "PUT":
		if len(requisicaoSubcategoria.Descricao) < 1 {
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Algum campo necessário para o cadastro não foi fornecido")
			return
		}

		var subcategoriaComDadosAtualizados modelos.Subcategoria
		subcategoriaComDadosAtualizados.IdSubcategoria = requisicaoSubcategoria.IdSubcategoria
		subcategoriaComDadosAtualizados.Descricao = requisicaoSubcategoria.Descricao

		subcategoriaAtualizado, erro := servicos.AtualizarSubcategoria(requisicaoSubcategoria.IdDaSessao, requisicaoSubcategoria.LoginDoUsuarioRequerente, subcategoriaComDadosAtualizados)

		if erro != servicos.ErroDeServicoDaSubcategoriaNenhum {
			erroServicoSubcategoriaParaErrHttp(erro, resposta)
			return
		}

		respostaSubcategoria := respostaSubcategoria{
			[]modelos.Subcategoria{
				subcategoriaAtualizado,
			},
		}
		respostaSubcategoriaJson, _ := json.Marshal(&respostaSubcategoria)

		fmt.Fprintf(resposta, "%s", respostaSubcategoriaJson)

	case "DELETE":
		if requisicaoSubcategoria.IdSubcategoria == 0 {
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "É necessário informar o IdSubcategoria da subcategoria que deseja excluir")
			return
		}

		if erro := servicos.DeletarSubcategoria(requisicaoSubcategoria.IdDaSessao, requisicaoSubcategoria.LoginDoUsuarioRequerente, requisicaoSubcategoria.IdSubcategoria); erro != servicos.ErroDeServicoDaSubcategoriaNenhum {
			erroServicoSubcategoriaParaErrHttp(erro, resposta)
			return
		}

		resposta.WriteHeader(http.StatusNoContent)
		fmt.Fprintf(resposta, "Categoria excluído com sucesso")
	}

}
