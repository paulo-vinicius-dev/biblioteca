package main

import (
	"biblioteca/banco"
	"biblioteca/rotas"
	"biblioteca/servicos"
	"log"
	"net/http"

	"github.com/joho/godotenv"
)

func main() {

	if err := godotenv.Load(); err != nil {
		log.Fatal("Erro ao carregar variáveis de ambiente!")
	}
	servicos.InicializarServicoEmail()
	banco.Inicializar()
	defer banco.Finalizar()
	http.HandleFunc("/login", rotas.Login)
	http.HandleFunc("/usuario", rotas.Usuario)
	http.HandleFunc("/autor", rotas.Autor)
	http.HandleFunc("/recuperarsenha", rotas.RecuperarSenha)
	http.HandleFunc("/turnos", rotas.Turnos)
	http.HandleFunc("/series", rotas.Series)
	http.HandleFunc("/turmas", rotas.Turma)
	http.ListenAndServe(":9090", nil)
}
