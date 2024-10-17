package modelos

import (
	"encoding/json"
	"time"
)

// Autor é uma struct que representa a tabela autor do banco de dados, possui os mesmo campos
type Autor struct {
	ID              int       `json:"id"`
	Nome            string    `json:"nome"`
	DataNascimento  time.Time `json:"data_nascimento"`
	Nacionalidade   uint8     `json:"nacionalidade"`
	Sexo            string    `json:"sexo"`
	DataCriacao     time.Time `json:"data_criacao"`
	DataAtualizacao time.Time `json:"data_atualizacao"`
}

// UnmarshalJSON utilizado como ponte para a conversão da requsição em struct Autor
func (a *Autor) UnmarshalJSON(data []byte) error {
	type ApelidoAutor Autor
	auxiliar := &struct {
		DataNascimento string `json:"data_nascimento"`
		*ApelidoAutor
	}{
		ApelidoAutor: (*ApelidoAutor)(a),
	}

	if err := json.Unmarshal(data, &auxiliar); err != nil {
		return err
	}

	var err error

	a.DataNascimento, err = time.Parse("2006-01-02", auxiliar.DataNascimento)

	return err
}
