package modelos

const (
	StatusExemplarLivroEmprestado = iota
	StatusExemplarLivroDisponivel
	StatusExemplarLivroIndisponivel
)

const (
	EstadoExemplarBom = iota
	EstadoExemplarDanificado
)

type ExemplarLivro struct {
	IdDoExemplarLivro int
	Livro             Livro
	Cativo            bool
	Status            int
	Estado            int
	Ativo             bool
}
