package banco

import (
	"biblioteca/modelos"
	"context"
	"fmt"

	pgx "github.com/jackc/pgx/v5"
)

type ErroBancoEmprestimo int

const (
	ErroBancoEmprestimoNenhum = iota
)
