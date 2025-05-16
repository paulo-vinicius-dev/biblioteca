package servicos

import (
	"biblioteca/banco"
	"biblioteca/modelos"
	"biblioteca/servicos/sessao"
	"biblioteca/utilidades"
	"context"
	"fmt"
	"os"
	"strconv"
	"time"
)

// Nota: Refatore para que não tenha dependencias cíclicas entre o pacote de
// servico e o pacote de servicos/usuario

type ErroServicoDoEmprestimo int

const (
	ErroServicoEmprestimoNenhum = iota
	ErroServicoEmprestimoExemplarNaoEncontrado
	ErroServicoEmprestimoExemplarEmprestado
	ErroServicoEmprestimoExemplarIndisponivel
	ErroServicoEmprestimoUsuarioNaoEncontrado
	ErroServicoEmprestimoObservacaoInvalida
	ErroServicoEmprestimoSessaoInvalida
	ErroServicoEmprestimoUsuarioSemPermissao
	ErroServicoEmprestimoEmprestimoNaoEncontrado
	ErroServicoEmprestimoNumeroMaximoDeRenovacoesAtingidos
)

func erroBancoEmprestimoParaErroServico(erro banco.ErroBancoEmprestimo) ErroServicoDoEmprestimo {
	switch erro {
	case banco.ErroBancoEmprestimoExemplarEmprestado:
		return ErroServicoEmprestimoExemplarEmprestado
	case banco.ErroBancoEmprestimoExemplarIndisponivel:
		return ErroServicoEmprestimoExemplarIndisponivel
	default:
		return ErroServicoEmprestimoNenhum
	}
}

func erroBancoDetalheEmprestimoParaErroServico(erro banco.ErroBancoDetalheEmprestimo) ErroServicoDoEmprestimo {
	switch erro {
	case banco.ErroBancoDetalheEmprestimoObservacaoInvalida:
		return ErroServicoEmprestimoObservacaoInvalida
	default:
		return ErroServicoEmprestimoNenhum
	}
}

func CriarEmprestimo(idDaSessao uint64, loginDoUsuario string, emprestimos []modelos.Emprestimo, detalhesEmprestimos []modelos.DetalheEmprestimo) ([]modelos.Emprestimo, []modelos.DetalheEmprestimo, ErroServicoDoEmprestimo) {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuario) != sessao.VALIDO {
		return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, ErroServicoEmprestimoSessaoInvalida
	}

	permissoesDoUsuario := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissoesDoUsuario&utilidades.PermissaoEmprestarLivro != utilidades.PermissaoEmprestarLivro {
		return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, ErroServicoEmprestimoUsuarioSemPermissao
	}

	transacao, _ := banco.CriarTransacao()
	defer func() {
		if transacao.Commit(context.Background()) != nil {
			transacao.Rollback(context.Background())
		}
	}()

	for indice, emprestimo := range emprestimos {
		exemplar, achou := banco.PegarExemplarPorId(emprestimo.Exemplar.IdDoExemplarLivro)

		if !achou {
			fmt.Println("Não pegou o bibliotecario")
			return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, ErroServicoEmprestimoUsuarioNaoEncontrado
		}

		usuario, achou := banco.PegarUsuarioPeloId(emprestimo.Usuario.IdDoUsuario)
		if !achou {
			fmt.Println("Não pegou o aluno")
			return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, ErroServicoEmprestimoUsuarioNaoEncontrado
		}

		emprestimos[indice].Usuario = usuario
		emprestimos[indice].Exemplar = exemplar
	}

	if erro := banco.CadastroEmprestimo(transacao, emprestimos); erro != banco.ErroBancoEmprestimoNenhum {
		return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, erroBancoEmprestimoParaErroServico(erro)
	}

	// essa pesquisa por usuário é retardada pois todos os empréstimos
	// são pro mesmo aluno
	// por favor suma com isso quando tiver tempo

	for indice, detalhe := range detalhesEmprestimos {
		fmt.Println("login do bibliotecario:", detalhe.Usuario.Login)
		usuario, erro := banco.PesquisarUsuarioPeloLogin(detalhe.Usuario.Login)
		if erro {
			fmt.Println("Não achou o aluno")
			return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, ErroServicoEmprestimoUsuarioNaoEncontrado
		}
		detalhesEmprestimos[indice].Usuario = usuario
		detalhesEmprestimos[indice].Acao = modelos.AcaoDetalheEmprestimoEmprestar
		detalhesEmprestimos[indice].Emprestimo = emprestimos[indice]
	}

	if erro := banco.CadastroDetalheEmprestimo(transacao, detalhesEmprestimos); erro != banco.ErroBancoDetalheEmprestimoNenhum {
		return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, erroBancoDetalheEmprestimoParaErroServico(erro)
	}

	return emprestimos, detalhesEmprestimos, ErroServicoEmprestimoNenhum
}

func PesquisarEmprestimo(idDaSessao uint64, loginDoUsuario string, idDoEmprestimo, idDoExemplar, idDoUsuarioEmprestimo, idDoUsuarioAluno int) ([]modelos.Emprestimo, []modelos.DetalheEmprestimo, ErroServicoDoEmprestimo) {
	if sessao.VerificaSeIdDaSessaoEValido(idDaSessao, loginDoUsuario) != sessao.VALIDO {
		return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, ErroServicoEmprestimoSessaoInvalida
	}

	permissoesDoUsuario := sessao.PegarSessaoAtual()[idDaSessao].Permissao

	if permissoesDoUsuario&utilidades.PermissaoEmprestarLivro != utilidades.PermissaoEmprestarLivro {
		return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, ErroServicoEmprestimoUsuarioSemPermissao
	}

	emprestimos := banco.PesquisarEmprestimo(idDoEmprestimo, idDoExemplar, idDoUsuarioEmprestimo, idDoUsuarioAluno)

	detalhes := make([]modelos.DetalheEmprestimo, 0)

	for indice, emprestimo := range emprestimos {
		usuarioEmprestimo, _ := banco.PegarUsuarioPeloId(emprestimo.Usuario.IdDoUsuario)
		emprestimos[indice].Usuario = usuarioEmprestimo
		exemplarEmprestimo, _ := PegarExemplarPeloId(emprestimo.Exemplar.IdDoExemplarLivro)
		emprestimos[indice].Exemplar = exemplarEmprestimo
		detalhes = append(detalhes, banco.PegarDetalheEmprestimoPorIdDoEmprestimo(emprestimo.IdDoEmprestimo)...)
	}

	for indice, detalhe := range detalhes {
		usuarioDetalhe, _ := banco.PegarUsuarioPeloId(detalhe.Usuario.IdDoUsuario)
		TurmaUsuarioDetalhe, _ := PegarTurmaPorId(usuarioDetalhe.Turma.IdTurma)
		usuarioDetalhe.Turma = TurmaUsuarioDetalhe
		detalhes[indice].Usuario = usuarioDetalhe
	}

	return emprestimos, detalhes, ErroServicoEmprestimoNenhum

}

// sei que esse método só retorna um item sempre
// mas para passar o resultado mais facilmente para a função paraRespostaEmprestimo
func RenovarEmprestimo(idDaSessao uint64, loginDoUsuario string, idDoEmprestimo int) ([]modelos.Emprestimo, []modelos.DetalheEmprestimo, ErroServicoDoEmprestimo) {
	transacao, _ := banco.CriarTransacao()
	defer func() {
		if transacao.Commit(context.Background()) != nil {
			transacao.Rollback(context.Background())
		}
	}()

	diasEmprestimo, erro := strconv.Atoi(os.Getenv("DIAS_EMPRESTIMO"))
	if erro != nil {
		panic("Configuração 'DIAS_EMPRESTIMO' é inválida ou inexistente")
	}

	emprestimo, detalhes, e := PesquisarEmprestimo(idDaSessao, loginDoUsuario, idDoEmprestimo, 0, 0, 0)

	if e != ErroServicoEmprestimoNenhum || len(emprestimo) == 0 || len(detalhes) == 0 {
		return emprestimo, detalhes, e
	}

	contadorRenovacoes := 0
	for _, detalhe := range detalhes {
		if detalhe.Acao == modelos.AcaoDetalheEmprestimoRenovar {
			contadorRenovacoes += 1
		}
	}

	if contadorRenovacoes > 2 {
		return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, ErroServicoEmprestimoNumeroMaximoDeRenovacoesAtingidos
	}

	dataEntregaPrevista, _ := time.Parse(time.DateOnly, emprestimo[0].DataDeEntregaPrevista)

	dataEntregaPrevista = dataEntregaPrevista.AddDate(0, 0, diasEmprestimo)

	emprestimo[0].DataDeEntregaPrevista = dataEntregaPrevista.Format(time.DateOnly)
	emprestimo[0].NumeroRenovacoes += 1

	if banco.AtualizarEmprestimo(transacao, emprestimo[0]) != banco.ErroBancoEmprestimoNenhum {
		transacao.Rollback(context.Background())
		return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, ErroServicoEmprestimoEmprestimoNaoEncontrado
	}

	usuario, erroUsuario := banco.PesquisarUsuarioPeloLogin(loginDoUsuario)
	if erroUsuario {
		return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, ErroServicoEmprestimoUsuarioNaoEncontrado
	}

	detalheRenovacao := modelos.DetalheEmprestimo{
		Emprestimo: emprestimo[0],
		Usuario:    usuario,
		DataHora:   time.Now().Format(time.DateOnly),
		Acao:       modelos.AcaoDetalheEmprestimoRenovar,
	}

	erroDetalheEmprestimo := banco.CadastroDetalheEmprestimo(
		transacao,
		[]modelos.DetalheEmprestimo{
			detalheRenovacao,
		},
	)

	if erroDetalheEmprestimo != banco.ErroBancoDetalheEmprestimoNenhum {
		return []modelos.Emprestimo{}, []modelos.DetalheEmprestimo{}, erroBancoDetalheEmprestimoParaErroServico(erroDetalheEmprestimo)
	}

	detalhes = append(detalhes, detalheRenovacao)

	return emprestimo, detalhes, ErroServicoEmprestimoNenhum
}
