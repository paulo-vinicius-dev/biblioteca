class Permissao {
  static const criarUsuario = 1;
  static const lerUsuario = 2;
  static const atualizarUsuario = 4;
  static const deletarUsuario = 8;

  static const crudUsuario =
      criarUsuario + lerUsuario + atualizarUsuario + deletarUsuario;
}
