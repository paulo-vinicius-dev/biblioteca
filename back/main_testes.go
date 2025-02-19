// +build testes

package main

import "biblioteca/testes"

func main() {
	testes.DeclararTeste(
		"Teste1", 
		func(dado interface{}) bool {
			return true
		},
		nil,
	)

	testes.DeclararTeste(
		"Teste2",
		func(dado interface{}) bool {
			return false
		},
		nil,
	)

	testes.Testar()
}
