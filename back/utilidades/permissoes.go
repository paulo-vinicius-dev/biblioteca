package utilidades

const (
	PermissaoCriarUsuario = 0b1
	PermssaoLerUsuario = 0b10
	PermissaoAtualizarUsuario = 0b100
	PermissaoDeletarUsuario = 0b1000

	PermissaoCrudUsuario = DeletarUsuario | AtualizarUsuario | LerUsuario | CriarUsuario
)
