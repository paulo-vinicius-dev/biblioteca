package utilidades

const (
	CriarUsuario = 0b1
	LerUsuario = 0b10
	AtualizarUsuario = 0b100
	DeletarUsuario = 0b1000

	CrudUsuario = DeletarUsuario | AtualizarUsuario | LerUsuario | CriarUsuario
)
