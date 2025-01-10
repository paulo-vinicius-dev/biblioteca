package utilidades

const (
	PermissaoCriarUsuario     = 0b1
	PermssaoLerUsuario        = 0b10
	PermissaoAtualizarUsuario = 0b100
	PermissaoDeletarUsuario   = 0b1000
	// As permissões de livros devem ser usadas nos exemplares também! :)
	PermissaoCriarLivro       = 0b10000 
	PermissaoAtualizarLivro   = 0b100000 
	PermissaoDeletarLivro     = 0b1000000

	PermissaoCrudUsuario = PermissaoDeletarUsuario | PermissaoAtualizarUsuario | PermssaoLerUsuario | PermissaoCriarUsuario
)
