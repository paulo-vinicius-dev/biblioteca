package main

import (
	"biblioteca/banco"
	"biblioteca/rotas"
	"net/http"
)

func main() {
	banco.Inicializar()
	defer banco.Finalizar()
	http.HandleFunc("/login", rotas.Login)
	http.HandleFunc("/usuario", rotas.Usuario)
	http.ListenAndServe(":9090", nil)
}
