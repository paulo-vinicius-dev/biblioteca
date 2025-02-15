package banco

import (
	"biblioteca/modelos"
	"context"
	"strings"

	pgx "github.com/jackc/pgx/v5"
)

type ErroBancoSubcategoria int

const (
	SubcategoriaErroNenhum = iota
	ErroSubcategoriaDescricaoDuplicada
	ErroSubcategoriaInexistente
	ErroSubcategoriaExecutarCriacao
	ErroSubcategoriaExecutarAtualizacao
	ErroSubcategoriaExecutarExclusao
)

func PesquisarSubcategoria(busca string) []modelos.Subcategoria {
	conexao := PegarConexao()
	busca = "%" + strings.ToLower(busca) + "%"
	textoQuery := `
		SELECT 
			sc.id_subcategoria,
			sc.descricao,
			sc.subcategoria,
			c.id_categoria,
			c.descricao
		FROM subcategoria sc
		INNER JOIN categoria c ON sc.categoria = c.id_categoria
		WHERE trim(lower(sc.id_subcategoria::varchar)) LIKE $1 
			OR trim(lower(sc.descricao)) LIKE $1
	`

	linhas, erro := conexao.Query(context.Background(), textoQuery, busca)
	if erro != nil {
		return []modelos.Subcategoria{}
	}
	var subcategoriaTemporaria modelos.Subcategoria
	subcategoriasEncontradas := make([]modelos.Subcategoria, 0)
	_, erro = pgx.ForEachRow(linhas, []any{
		&subcategoriaTemporaria.IdSubcategoria,
		&subcategoriaTemporaria.Descricao,
		&subcategoriaTemporaria.Categoria.IdDaCategoria,
		&subcategoriaTemporaria.Categoria.Descricao,
	}, func() error {
		subcategoriasEncontradas = append(subcategoriasEncontradas, subcategoriaTemporaria)
		return nil
	})
	if erro != nil {
		return []modelos.Subcategoria{}
	}
	return subcategoriasEncontradas
}

func PegarTodasSubcategorias() []modelos.Subcategoria {
	conexao := PegarConexao()
	textoQuery := `
		SELECT 
			sc.id_subcategoria,
			sc.descricao,
			sc.subcategoria,
			c.id_categoria,
			c.descricao
		FROM subcategoria sc
		INNER JOIN categoria c ON sc.categoria = c.id_categoria
	`
	linhas, erro := conexao.Query(context.Background(), textoQuery)
	if erro != nil {
		return []modelos.Subcategoria{}
	}

	var subcategoriaTemporaria modelos.Subcategoria
	subcategoriasEncontradas := make([]modelos.Subcategoria, 0)
	_, erro = pgx.ForEachRow(linhas, []any{
		&subcategoriaTemporaria.IdSubcategoria,
		&subcategoriaTemporaria.Descricao,
		&subcategoriaTemporaria.Categoria.IdDaCategoria,
		&subcategoriaTemporaria.Categoria.Descricao,
	}, func() error {
		subcategoriasEncontradas = append(subcategoriasEncontradas, subcategoriaTemporaria)
		return nil
	})
	if erro != nil {
		return []modelos.Subcategoria{}
	}
	return subcategoriasEncontradas
}

func CriarSubcategoria(novasubcategoria modelos.Subcategoria) ErroBancoSubcategoria {
	conexao := PegarConexao()

	_, erroQuery := conexao.Exec(context.Background(),
		"INSERT INTO subcategoria (descricao, categoria, data_criaca) VALUES ($1, current_timestamp)",
		novasubcategoria.Descricao,
		novasubcategoria.Categoria.IdDaCategoria,
	)

	if erroQuery != nil {
		return ErroCategoriaExecutarCriacao
	}
	return CategoriaErroNenhum
}

func PegarSubcategoriaPeloId(id int) (modelos.Subcategoria, bool) {
	conexao := PegarConexao()
	var subcategoria modelos.Subcategoria
	textoQuery := `
		SELECT 
			sc.id_subcategoria, 
			sc.descricao, 
			c.id_categoria, 
			c.descricao
		FROM subcategoria sc
		INNER JOIN categoria c ON sc.categoria = c.id_categoria
		WHERE sc.id_subcategoria = $1
	`

	if erro := conexao.QueryRow(context.Background(), textoQuery, id).Scan(
		&subcategoria.IdSubcategoria,
		&subcategoria.Descricao,
		&subcategoria.Categoria.IdDaCategoria,
		&subcategoria.Categoria.Descricao,
	); erro == nil {
		return subcategoria, true
	} else {
		return subcategoria, false
	}
}

func AtualizarSubcategoria(subcategoria modelos.Subcategoria) ErroBancoSubcategoria {
	conexao := PegarConexao()

	query := "UPDATE subcategoria SET descricao = $1, data_atualizacao = current_timestamp WHERE id_categoria = $2"
	if _, erroQuery := conexao.Exec(
		context.Background(), query, subcategoria.Descricao, subcategoria.IdSubcategoria,
	); erroQuery != nil {
		return ErroSubcategoriaExecutarAtualizacao
	}

	return ErroNenhum
}

func ExcluirSubcategoria(IdSubcategoria int) ErroBancoSubcategoria {
	conexao := PegarConexao()

	if _, erroQuery := conexao.Exec(
		context.Background(),
		"DELETE FROM subcategoria WHERE id_subcategoria = $1", IdSubcategoria,
	); erroQuery != nil {
		return ErroCategoriaExecutarExclusao
	}

	return ErroNenhum
}

func PegarIdSubcategoria(descricao string) int {
	conexao := PegarConexao()
	var id int
	if conexao.QueryRow(context.Background(), "SELECT id_subcategoria FROM subcategoria WHERE descricao = $1", descricao).Scan(&id) == nil {
		return id
	} else {
		return 0
	}
}
