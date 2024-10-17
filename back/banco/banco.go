package banco

import (
	"context"
	"log"

	"github.com/jackc/pgx/v5/pgxpool"
)

var dbpool *pgxpool.Pool

func Inicializar() {
	var erro error
	dbpool, erro = pgxpool.New(context.Background(), "postgres://postgres:2907@localhost:5432/postgres?options=-c%20search_path%3Dbiblioteca")
	if erro != nil {
		log.Fatal("Não foi Possível se conectar no banco de dados")
	}
}

func PegarConexao() *pgxpool.Pool {
	return dbpool
}

func Finalizar() {
	if dbpool != nil {
		dbpool.Close()
	}
}
