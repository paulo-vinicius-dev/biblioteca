package banco

import (
	"biblioteca/modelos"
	"context"
	"fmt"
	"strings"
)

type ErroBancoSubcategoria int

const (
	SubcategoriaErroNenhum ErroBancoSubcategoria = iota
	ErroSubcategoriaDescricaoDuplicada
	ErroSubcategoriaInexistente
	ErroSubcategoriaExecutarCriacao
	ErroSubcategoriaExecutarAtualizacao
	ErroSubcategoriaExecutarExclusao
)

func PesquisarSubcategoria(busca string) []modelos.Subcategoria {
	conexao := PegarConexao()

	busca = "%" + strings.ToLower(busca) + "%"
	query := `
		SELECT 
			id_subcategoria,
			descricao
		FROM subcategoria
		WHERE trim(lower(id_subcategoria::varchar)) LIKE $1 
			OR trim(lower(descricao)) LIKE $1
	`

	linhas, err := conexao.Query(context.Background(), query, busca)
	if err != nil {
		fmt.Println("Erro ao executar a consulta:", err)
		return nil
	}
	defer linhas.Close()

	var subcategorias []modelos.Subcategoria
	for linhas.Next() {
		var subcategoria modelos.Subcategoria
		if err := linhas.Scan(&subcategoria.IdSubcategoria, &subcategoria.Descricao); err != nil {
			fmt.Println("Erro ao escanear linha:", err)
			continue
		}
		subcategorias = append(subcategorias, subcategoria)
	}

	if err := linhas.Err(); err != nil {
		fmt.Println("Erro ao iterar sobre as linhas:", err)
		return nil
	}

	return subcategorias
}

func PegarTodasSubcategorias() []modelos.Subcategoria {
	conexao := PegarConexao()

	query := `
		SELECT 
			id_subcategoria,
			descricao
		FROM subcategoria
	`

	linhas, err := conexao.Query(context.Background(), query)
	if err != nil {
		fmt.Println("Erro ao executar a consulta:", err)
		return nil
	}
	defer linhas.Close()

	var subcategorias []modelos.Subcategoria
	for linhas.Next() {
		var subcategoria modelos.Subcategoria
		if err := linhas.Scan(&subcategoria.IdSubcategoria, &subcategoria.Descricao); err != nil {
			fmt.Println("Erro ao escanear linha:", err)
			continue
		}
		subcategorias = append(subcategorias, subcategoria)
	}

	if err := linhas.Err(); err != nil {
		fmt.Println("Erro ao iterar sobre as linhas:", err)
		return nil
	}

	return subcategorias
}

func CriarSubcategoria(novaSubcategoria modelos.Subcategoria) ErroBancoSubcategoria {
	conexao := PegarConexao()

	query := "INSERT INTO subcategoria (descricao) VALUES ($1)"
	_, err := conexao.Exec(context.Background(), query, novaSubcategoria.Descricao)
	if err != nil {
		fmt.Println("Erro ao criar subcategoria:", err)
		return ErroSubcategoriaExecutarCriacao
	}

	return SubcategoriaErroNenhum
}

func PegarSubcategoriaPeloId(id int) (modelos.Subcategoria, bool) {
	conexao := PegarConexao()

	var subcategoria modelos.Subcategoria
	query := `
		SELECT 
			id_subcategoria, 
			descricao
		FROM subcategoria
		WHERE id_subcategoria = $1
	`

	err := conexao.QueryRow(context.Background(), query, id).Scan(
		&subcategoria.IdSubcategoria,
		&subcategoria.Descricao,
	)
	if err != nil {
		fmt.Println("Erro ao buscar subcategoria pelo ID:", err)
		return subcategoria, false
	}

	return subcategoria, true
}

func AtualizarSubcategoria(subcategoria modelos.Subcategoria) ErroBancoSubcategoria {
	conexao := PegarConexao()

	query := `
		UPDATE subcategoria 
		SET descricao = $1, data_atualizacao = current_timestamp 
		WHERE id_subcategoria = $2
	`
	_, err := conexao.Exec(context.Background(), query, subcategoria.Descricao, subcategoria.IdSubcategoria)
	if err != nil {
		fmt.Println("Erro ao atualizar subcategoria:", err)
		return ErroSubcategoriaExecutarAtualizacao
	}

	return SubcategoriaErroNenhum
}

func ExcluirSubcategoria(idSubcategoria int) ErroBancoSubcategoria {
	conexao := PegarConexao()

	query := "DELETE FROM subcategoria WHERE id_subcategoria = $1"
	_, err := conexao.Exec(context.Background(), query, idSubcategoria)
	if err != nil {
		fmt.Println("Erro ao excluir subcategoria:", err)
		return ErroSubcategoriaExecutarExclusao
	}

	return SubcategoriaErroNenhum
}

func PegarIdSubcategoria(descricao string) int {
	conexao := PegarConexao()

	var id int
	query := "SELECT id_subcategoria FROM subcategoria WHERE descricao = $1"
	err := conexao.QueryRow(context.Background(), query, descricao).Scan(&id)
	if err != nil {
		fmt.Println("Erro ao buscar ID da subcategoria:", err)
		return 0
	}

	return id
}
