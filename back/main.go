package main

import "net/http"
import "biblioteca/rotas"

func main() {

	http.HandleFunc("/login", rotas.Login)
	http.ListenAndServe(":9090", nil)
}
