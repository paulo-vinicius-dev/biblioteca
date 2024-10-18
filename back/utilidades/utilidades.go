package utilidades

import "unicode"

func calcularDigitosVerificadores(cpf string, primeiroDigito bool) int {
	somaDigitos := 0

	for indice, caractere := range cpf {
		if indice < len(cpf)-1 {
			if primeiroDigito {
				somaDigitos += (int(caractere) - int('0')) * (indice + 1)
				if indice == 8 {
					break
				}
			} else {
				somaDigitos += (int(caractere) - int('0')) * indice
			}
		}
	}

	if somaDigitos%11 == 10 {
		return 0
	} else {
		return somaDigitos % 11
	}
}

func ValidarCpf(cpf string) bool {

	if len(cpf) != 11 {
		return false
	}
	primeiroDigitoVerificadorFornecido := 0
	segundoDigitoVerificadorFornecido := 0
	for indice, caractere := range cpf {
		if tamanhoCpf := len(cpf); indice == tamanhoCpf-2 {
			primeiroDigitoVerificadorFornecido = int(caractere) - int('0')
		} else if indice == tamanhoCpf-1 {
			segundoDigitoVerificadorFornecido = int(caractere) - int('0')
		}

	}

	return primeiroDigitoVerificadorFornecido == calcularDigitosVerificadores(cpf, true) && segundoDigitoVerificadorFornecido == calcularDigitosVerificadores(cpf, false)

}

func StringENumerica(s string) bool {
	for _, c := range s {
		if !unicode.IsDigit(c) {
			return false
		}
	}
	return true
}
