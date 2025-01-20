package banco

import "biblioteca/modelos"
import "context"
import pgx "github.com/jackc/pgx/v5"
import "fmt"
type ErroBancoPais int

const (
	ErroBancoPaisNenhum = iota
	ErroBancoPaisInexistente
	ErroBancoPaisExistente
	ErroBancoPaisNomeOuSiglaDuplicado
)


func CadastrarPais(novoPais modelos.Pais) (modelos.Pais, ErroBancoPais) {
	conexao := PegarConexao()
	_, achou := PegarPaisPeloId(novoPais.IdDoPais)
	if !achou {
		return modelos.Pais{}, ErroBancoPaisExistente
	}

	textoDaQuery := "insert into pais(nome, sigla, ativo) values($1, $1)"
	_, erro := conexao.Exec(
		context.Background(),
		textoDaQuery,
		novoPais.Nome,
		novoPais.Sigla,
		true,
	)

	if erro != nil {
		fmt.Println(erro)
		panic("Um erro inesperado acontesceu. Provavelmente é um bug")
	}

	textoDaQuery = "select max(id_pais) from pais"

	conexao.QueryRow(context.Background(), textoDaQuery).Scan(&novoPais.IdDoPais)

	return novoPais, ErroBancoPaisNenhum
}

func BuscarPaises(pais modelos.Pais) []modelos.Pais {
	if pais.IdDoPais != 0 {
		if paisAchado, achou := PegarPaisPeloId(pais.IdDoPais); achou {
			return []modelos.Pais{
				paisAchado,
			}
		} else {
			return []modelos.Pais{}
		}
	}

	if pais.Nome == "" && pais.Sigla == "" {
		paises := PegarTodosOsPaises()
		paisesEncontrados := make([]modelos.Pais, 0, 20)
		if paises == nil {
			return []modelos.Pais{}
		}
		// código meio paia	
		for _, pais := range paises {
			paisesEncontrados = append(paisesEncontrados, pais)	
		}
		return paisesEncontrados
	}

	textoQuery := "select id_pais, nome, sigla, ativo from pais where nome = $1 or sigla = $2"

	conexao := PegarConexao()
	linhas, erro := conexao.Query(context.Background(), textoQuery, pais.Nome, pais.Sigla)
	var paisTemporario modelos.Pais
	paisesEncontrados := make([]modelos.Pais, 0, 20)
	_, erro = pgx.ForEachRow(
		linhas,
		[]any{
			&paisTemporario.IdDoPais,
			&paisTemporario.Nome,
			&paisTemporario.Sigla, 
			&paisTemporario.Ativo,
		},
		func () error {
			paisesEncontrados = append(paisesEncontrados, paisTemporario)	
			return nil
		},
	)
	if erro != nil {
		return nil
	}

	return paisesEncontrados
}


func AtualizarPais(paisComDadosAtualizados modelos.Pais) ErroBancoPais {
	if _, achou := PegarPaisPeloId(paisComDadosAtualizados.IdDoPais); !achou {
		return ErroBancoPaisInexistente 
	}

	for _, p := range BuscarPaises(modelos.Pais{Nome: paisComDadosAtualizados.Nome, Sigla: paisComDadosAtualizados.Sigla}) {
		if p.IdDoPais != paisComDadosAtualizados.IdDoPais {
			return ErroBancoPaisNomeOuSiglaDuplicado
		}
	}

	conexao := PegarConexao()
	textoQuery := "update pais set nome = $1, sigla = $2, ativo = $3"
	if _, erroQuery := conexao.Query(
		context.Background(),
		textoQuery,
		paisComDadosAtualizados.Nome,
		paisComDadosAtualizados.Sigla,
		paisComDadosAtualizados.Ativo,
	); erroQuery != nil {
		panic("Um erro desconhecido acontesceu na atualização do pais")
	}
	
	return ErroBancoPaisNenhum

}

func DeletarPais(exemplarASerExcluido modelos.Pais)  ErroBancoPais {
	exemplarASerExcluido.Ativo = false
	return AtualizarPais(exemplarASerExcluido)
}

func PegarPaisPeloId(idDoPais int) (modelos.Pais, bool) {
	conexao := PegarConexao()
	textoQuery := "select id_pais, nome, sigla, ativo from pais where id_pais = $1"
	var pais modelos.Pais
	if erro := conexao.QueryRow(context.Background(), textoQuery, idDoPais).Scan(
		&pais.IdDoPais,
		&pais.Nome,
		&pais.Sigla,
		&pais.Ativo,
	); erro != nil {
		return pais, false 
	}

	return pais, true

}



func PegarTodosOsPaises() map[int]modelos.Pais {
	conexao := PegarConexao()
	textoQuery := "select id_pais, nome, sigla, ativo from pais"
	linhas, erro := conexao.Query(context.Background(), textoQuery)
	if erro != nil {
		return nil
	}
	var paisTemporario modelos.Pais
	paisesEncontrados := make(map[int]modelos.Pais)
	_, erro = pgx.ForEachRow(
		linhas,
		[]any{
			&paisTemporario.IdDoPais,
			&paisTemporario.Nome,
			&paisTemporario.Sigla, 
			&paisTemporario.Ativo, 
		},
		func () error {
			paisesEncontrados[paisTemporario.IdDoPais] = paisTemporario
			return nil
		},
	)
	if erro != nil {
		return nil
	}
	return paisesEncontrados
}
