package modelos

type Usuario struct {
	IdDoUsuario      int
	Login            string
	Cpf              string
	Senha            string
	Nome             string
	Email            string
	Telefone         string
	DataDeNascimento string
	Permissao        uint64
	Ativo            bool
}
