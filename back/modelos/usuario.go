package modelos

import "time"

type Usuario struct {
	IdDoUsuario int
	Login string
	Senha string
	Nome string
	Email string
	Telefone string
	DataDeNascimento time.Time
	DataCriacao time.Time
	DataAtualizacao time.Time
	Permissao uint64
}