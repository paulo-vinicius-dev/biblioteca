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
	IdDaSessao               uint64
	LoginDoUsuarioRequerente string
	Id                       int
	Login                    string
	Cpf                      string
	Senha                    string
	Nome                     string
	Email                    string
	Telefone                 string
	DataDeNascimento         string
	PermissoesDoUsuario     uint64
}

type respostaUsuario struct {
	UsuarioAtingidos []modelos.Usuario
}

func Usuario(resposta http.ResponseWriter, requisicao *http.Request) {

	corpoDaRequisicao, erro := io.ReadAll(requisicao.Body)

	if erro != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de criação foi mal feita")
		return
	}

	var requisicaoUsuario requisicaoUsuario
	if json.Unmarshal(corpoDaRequisicao, &requisicaoUsuario) != nil {
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "A requisição para a rota de criação foi mal feita")
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
		fmt.Println("CPF:", novoUsuario.Cpf)
		switch servicoUsuario.CriarUsuario(requisicaoUsuario.IdDaSessao, requisicaoUsuario.LoginDoUsuarioRequerente, novoUsuario) {
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

		}

		novoUsuario.IdDoUsuario = servicoUsuario.PegarIdUsuario(novoUsuario.Login)

		respostaUsuario := respostaUsuario{
			[]modelos.Usuario{
				novoUsuario,
			},
		}

		respostaUsuarioJson, _ := json.Marshal(&respostaUsuario)

		fmt.Fprintf(resposta, "%s", respostaUsuarioJson)

		return

	}

}
