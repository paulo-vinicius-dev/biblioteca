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
	Ids                      []int
	Logins                   []string
	Cpfs                     []string
	Senhas                   []string
	Nomes                    []string
	Emails                   []string
	Telefones                []string
	DatasDeNascimento        []string
	PermissoesDosUsuarios    []uint64
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

	usuarioRequerente := modelos.Usuario{
		Login:     requisicaoUsuario.LoginDoUsuarioRequerente,
		Permissao: servicoUsuario.PegarPermissao(requisicaoUsuario.LoginDoUsuarioRequerente),
	}

	switch requisicao.Method {
	case "POST":
		if len(requisicaoUsuario.Logins) < 1 ||
			len(requisicaoUsuario.Cpfs) < 1 ||
			len(requisicaoUsuario.Nomes) < 1 ||
			len(requisicaoUsuario.Emails) < 1 ||
			len(requisicaoUsuario.Telefones) < 1 ||
			len(requisicaoUsuario.DatasDeNascimento) < 1 ||
			len(requisicaoUsuario.PermissoesDosUsuarios) < 1 {
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Algum campo necessário para o cadastro não foi fornecido")
			return
		}

		var novoUsuario modelos.Usuario
		novoUsuario.Login = requisicaoUsuario.Logins[0]
		novoUsuario.Cpf = requisicaoUsuario.Cpfs[0]
		novoUsuario.Nome = requisicaoUsuario.Nomes[0]
		novoUsuario.Email = requisicaoUsuario.Emails[0]
		novoUsuario.Telefone = requisicaoUsuario.Telefones[0]
		novoUsuario.DataDeNascimento = requisicaoUsuario.DatasDeNascimento[0]
		novoUsuario.Permissao = requisicaoUsuario.PermissoesDosUsuarios[0]
		fmt.Println("CPF:", novoUsuario.Cpf)
		switch servicoUsuario.CriarUsuario(requisicaoUsuario.IdDaSessao, usuarioRequerente, novoUsuario) {
		case servicoUsuario.ErroDeServicoDoUsuarioLoginDuplicado:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Login duplicado")
			return
		case servicoUsuario.ErroDeServicoDoUsuarioCpfDuplicado:
			resposta.WriteHeader(http.StatusBadRequest)
			fmt.Fprintf(resposta, "Cpf duplicado")
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
