package rotas

import (
	"biblioteca/modelos"
	servicoUsuario "biblioteca/servicos/usuario"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
)

type requisicaoUsuario struct {
	IdDaSessao               uint64 `validate:"required"`
	LoginDoUsuarioRequerente string `validate:"required"`
	Id                       int	`validate:"optional"`
	Login                    string `validate:"optional"`
	Cpf                      string `validate:"optional"`
	Senha                    string `validate:"optional"`
	Nome                     string `validate:"optional"`
	Email                    string `validate:"optional"`
	Telefone                 string `validate:"optional"`
	DataDeNascimento         string `validate:"optional"`
	PermissoesDoUsuario      uint64 `validate:"optional"`
	Ativo                    bool   `validate:"optional"`
	Turma                    int    `validate:"optional"`
	TextoDeBusca             string `validate:"optional"` // usado somente quando se procura um usuário
}

type respostaUsuario struct {
	UsuarioAtingidos []modelos.Usuario
}

func erroServicoUsuarioParaErrHttp(erro servicoUsuario.ErroDeServicoDoUsuario, resposta http.ResponseWriter) {
	switch erro {
		case servicoUsuario.ErroDeServicoDoUsuarioLoginDuplicado:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Login duplicado")
			return
		case servicoUsuario.ErroDeServicoDoUsuarioCpfDuplicado:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Cpf duplicado")
			return
		case servicoUsuario.ErroDeServicoDoUsuarioEmailDuplicado:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Email duplicado")
			return
		case servicoUsuario.ErroDeServicoDoUsuarioEmailInvalido:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Email inválido")
			return
		case servicoUsuario.ErroDeServicoDoUsuarioErroDesconhecido:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Erro desconhecido provavelmente por conta do sql")
			return
		case servicoUsuario.ErroDeServicoDoUsuarioTelefoneInvalido:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Telefone inválido!")
			return

		case servicoUsuario.ErroDeServicoDoUsuarioSemPermisao:
			resposta.WriteHeader(http.StatusForbidden)
			fmt.Fprintf(resposta, "Este usuário não tem permissão para essa operação")
			return
		case servicoUsuario.ErroDeServicoDoUsuarioSessaoInvalida:
			resposta.WriteHeader(http.StatusUnauthorized)
			fmt.Fprintf(resposta, "Este usuário não está autorizado(logado). Sessão inválida?")
			return
		case servicoUsuario.ErroDeServicoDoUsuarioCpfInvalido:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Cpf inválido!")
			return
		case servicoUsuario.ErroDeServicoDoUsuarioDataDeNascimentoInvalida:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Data de nascimento inválida! deve estar no formato AAAA-MM-DD!")
			return
		case servicoUsuario.ErroDeServicoDoUsuarioUsuarioInexistente:
			resposta.WriteHeader(http.StatusNotFound)
			fmt.Fprintf(resposta, "Foi tentado atualizar um usuário inexistente")
			return
		/*case servicoUsuario.ErroDeServicoDoUsuarioTurmaInvalida:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "A turma fornecida é inválida!")
			return 
		*/
	}
}

func Usuario(resposta http.ResponseWriter, requisicao *http.Request) {

	corpoDaRequisicao, erro := io.ReadAll(requisicao.Body)

	if erro != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de usuario foi mal feita")
		return
	}

	var requisicaoUsuario requisicaoUsuario
	if json.Unmarshal(corpoDaRequisicao, &requisicaoUsuario) != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de usuario foi mal feita")
		return
	}

	if requisicaoUsuario.LoginDoUsuarioRequerente == "" {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de usuario foi mal feita")
		return
	}

	switch requisicao.Method {
	case "POST":
		if len(requisicaoUsuario.Login) < 1 ||
			len(requisicaoUsuario.Cpf) < 1 ||
			len(requisicaoUsuario.Nome) < 1 ||
			len(requisicaoUsuario.Email) < 1 ||
			len(requisicaoUsuario.Telefone) < 1 ||
			len(requisicaoUsuario.Senha) < 1 ||
			len(requisicaoUsuario.DataDeNascimento) < 1 {
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Algum campo necessário para o cadastro não foi fornecido")
			return
		}

		var novoUsuario modelos.Usuario
		novoUsuario.Login = requisicaoUsuario.Login
		novoUsuario.Cpf = requisicaoUsuario.Cpf
		novoUsuario.Nome = requisicaoUsuario.Nome
		novoUsuario.Email = requisicaoUsuario.Email
		novoUsuario.Telefone = requisicaoUsuario.Telefone
		novoUsuario.DataDeNascimento = requisicaoUsuario.DataDeNascimento
		novoUsuario.Permissao = requisicaoUsuario.PermissoesDoUsuario
		novoUsuario.Senha = requisicaoUsuario.Senha
		novoUsuario.Turma = requisicaoUsuario.Turma

		erro := servicoUsuario.CriarUsuario(requisicaoUsuario.IdDaSessao, requisicaoUsuario.LoginDoUsuarioRequerente, novoUsuario)

		if erro != servicoUsuario.ErroDeServicoDoUsuarioNenhum {
			erroServicoUsuarioParaErrHttp(erro, resposta)
			return
		}

		novoUsuario.IdDoUsuario = servicoUsuario.PegarIdUsuario(novoUsuario.Login)
		novoUsuario.Ativo = true

		respostaUsuario := respostaUsuario{
			[]modelos.Usuario{
				novoUsuario,
			},
		}

		respostaUsuarioJson, _ := json.Marshal(&respostaUsuario)

		fmt.Fprintf(resposta, "%s", respostaUsuarioJson)

		return


	case "GET":
		usuariosEncontrados, erro := servicoUsuario.BuscarUsuarios(requisicaoUsuario.IdDaSessao,requisicaoUsuario.LoginDoUsuarioRequerente,  requisicaoUsuario.TextoDeBusca)
		if erro == servicoUsuario.ErroDeServicoDoUsuarioSemPermisao {
			resposta.WriteHeader(http.StatusForbidden)
			fmt.Fprintf(resposta, "Este usuário não tem permissão para essa operação")
			return
		} else if erro == servicoUsuario.ErroDeServicoDoUsuarioFalhaNaBusca {
			resposta.WriteHeader(http.StatusInternalServerError)
			fmt.Fprint(resposta, "Houve um erro interno enquanto se fazia a busca! Provavelmente é um bug na api!") // mudar para um assert
			return
		}
		respostaUsuario := respostaUsuario{
			usuariosEncontrados,
		}
		respostaUsuarioJson, _ := json.Marshal(&respostaUsuario)

		fmt.Fprintf(resposta, "%s", respostaUsuarioJson)

	case "PUT":
		if len(requisicaoUsuario.Login) < 1 ||
			len(requisicaoUsuario.Cpf) < 1 ||
			len(requisicaoUsuario.Nome) < 1 ||
			len(requisicaoUsuario.Email) < 1 ||
			requisicaoUsuario.Id == 0 {
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Algum campo necessário para a atualização não foi fornecido")
			return
		}

		var usuarioComDadosAtualizados modelos.Usuario
		usuarioComDadosAtualizados.Login = requisicaoUsuario.Login
		usuarioComDadosAtualizados.Cpf = requisicaoUsuario.Cpf
		usuarioComDadosAtualizados.Nome = requisicaoUsuario.Nome
		usuarioComDadosAtualizados.Email = requisicaoUsuario.Email
		usuarioComDadosAtualizados.Telefone = requisicaoUsuario.Telefone
		usuarioComDadosAtualizados.DataDeNascimento = requisicaoUsuario.DataDeNascimento
		usuarioComDadosAtualizados.Permissao = requisicaoUsuario.PermissoesDoUsuario
		usuarioComDadosAtualizados.Senha = requisicaoUsuario.Senha
		usuarioComDadosAtualizados.IdDoUsuario = requisicaoUsuario.Id

		usuarioAtualizado, erro := servicoUsuario.AtualizarUsuario(requisicaoUsuario.IdDaSessao, requisicaoUsuario.LoginDoUsuarioRequerente, usuarioComDadosAtualizados)

		if erro != servicoUsuario.ErroDeServicoDoUsuarioNenhum {
			erroServicoUsuarioParaErrHttp(erro, resposta)
			return
		}

		respostaUsuario := respostaUsuario{
			[]modelos.Usuario{
				usuarioAtualizado,
			},
		}
		respostaUsuarioJson, _ := json.Marshal(&respostaUsuario)

		fmt.Fprintf(resposta, "%s", respostaUsuarioJson)

	case "DELETE":
		if requisicaoUsuario.Id == 0 {
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "É necessário informar o Id do usuário que deseja excluir")
			return
		}

		if erro := servicoUsuario.DeletarUsuario(requisicaoUsuario.IdDaSessao, requisicaoUsuario.LoginDoUsuarioRequerente, requisicaoUsuario.Id); erro != servicoUsuario.ErroDeServicoDoUsuarioNenhum {
			erroServicoUsuarioParaErrHttp(erro, resposta)
		}
		usuarioDeletado, _ := servicoUsuario.PegarUsuarioPeloId(requisicaoUsuario.Id)
		respostaUsuario := respostaUsuario{
			[]modelos.Usuario{
				usuarioDeletado,
			},
		}

		respostaUsuarioJson, _ := json.Marshal(&respostaUsuario)

		fmt.Fprintf(resposta, "%s", respostaUsuarioJson)


	}

}
