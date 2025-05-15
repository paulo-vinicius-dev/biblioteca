// +build testes

package main

import "biblioteca/testes"
import "biblioteca/utilidades"
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

	testes.DeclararTeste(
		"Cpf com string vazia deveria retornar false",
		func(dado interface{}) bool {
			return utilidades.ValidarCpf("") == false;
		},
		nil,
	)

	testes.DeclararTeste(
		"Cpf com menos de 11 digitos deveria retornar false",
		func(dado interface{}) bool {
			cpf, _ := dado.(string)
			return utilidades.ValidarCpf(cpf) == false;
		},
		"123",
	)

	testes.DeclararTeste(
		"Cpf com mais de 11 digitos deveria retornar false",
		func(dado interface{}) bool {
			cpf, _ := dado.(string)
			return utilidades.ValidarCpf(cpf) == false;
		},
		"1234567891112",
	)

	testes.DeclararTeste(
		"Cpf 11111111111 deveria retornar false",
		func(dado interface{}) bool {
			return utilidades.ValidarCpf("11111111111") == false;
		},
		nil,
	)

	testes.DeclararTeste(
		"Cpf 70126694036 deveria retornar true",
		func(dado interface{}) bool {
			return utilidades.ValidarCpf("70126694036") == true;
		},
		nil,
	)

	testes.DeclararTeste(
		"Cpf 25684298010 deveria retornar true",
		func(dado interface{}) bool {
			return utilidades.ValidarCpf("25684298010") == true;
		},
		nil,
	)

	testes.DeclararTeste(
		"Cpf 31237107008 deveria retornar true",
		func(dado interface{}) bool {
			return utilidades.ValidarCpf("31237107008") == true;
		},
		nil,
	)

	utilidades.DeclararTesteUtilidades()

	testes.Testar()
}
