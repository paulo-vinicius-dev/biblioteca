package main

import "net/http"
import "biblioteca/rotas"
import "biblioteca/banco"

func main() {
	banco.Inicializar()
	defer banco.Finalizar()
	http.HandleFunc("/login", rotas.Login)
	http.ListenAndServe(":9090", nil)
}
