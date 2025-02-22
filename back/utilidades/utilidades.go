package utilidades

import (
	"regexp"
	"strconv"
	"strings"
	"unicode"
	"biblioteca/testes"
)

func DeclararTesteUtilidades() {
	testes.DeclararTeste(
		"primeiro dígito verificador do cpf 11144477705 deve ser 3",
		func(dado interface{}) bool {
			return calcularDigitosVerificadores("11144477705", true) == 3
		},
		nil,
	)

	testes.DeclararTeste(
		"segundo dígito verificador do cpf 11144477705 deve ser 5",
		func(dado interface{}) bool {
			return calcularDigitosVerificadores("11144477705", false) == 5
		},
		nil,
	)
}

const emailRegex = `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`




func calcularDigitosVerificadores(cpf string, primeiroDigito bool) int {
	if primeiroDigito {
		somaDigitos := 0
		numeroParaMultiplicar := 2
		for i := 8; i >= 0; i -= 1 {
			somaDigitos += (int(cpf[i]) - int('0')) * numeroParaMultiplicar
			numeroParaMultiplicar += 1
		}
		resto := somaDigitos % 11
		if resto < 2 {
			return 0
		} else {
			return 11 - resto
		}

	} else {
		somaDigitos := calcularDigitosVerificadores(cpf, true) * 2
		numeroParaMultiplicar := 3
		for i := 8; i > -1; i -= 1 {
			somaDigitos += (int(cpf[i]) - int('0')) * numeroParaMultiplicar
			numeroParaMultiplicar += 1
		}

		resto := somaDigitos % 11
		if resto < 2 {
			return 0
		} else {
			return 11 - resto
		}
	}



}


func ValidarCpf(cpf string) bool {

	if len(cpf) != 11 {
		return false
	}

	if strings.Count(cpf, string(cpf[0])) == len(cpf) {
		return false
	}

	primeiroDigito := calcularDigitosVerificadores(cpf, true)
	segundoDigito := calcularDigitosVerificadores(cpf, false)
	return primeiroDigito == (int(cpf[len(cpf) - 2]) - int('0')) &&
	       segundoDigito == (int(cpf[len(cpf) - 1]) - int('0'))

}

func ValidarEmail(email string) bool {
	deuMatch, erro := regexp.MatchString(emailRegex, email)
	if erro != nil {
		return true
	}
	return deuMatch
}

func StringENumerica(s string) bool {
	for _, c := range s {
		if !unicode.IsDigit(c) {
			return false
		}
	}
	return true
}

func ValidarISBN(isbn string) bool {
	isbn = strings.ReplaceAll(isbn, "-", "")
	isbn = strings.ReplaceAll(isbn, " ", "")

	if len(isbn) == 10 {
		return validarISBN10(isbn)
	} else if len(isbn) == 13 {
		return validarISBN13(isbn)
	}
	return false
}

func validarISBN10(isbn string) bool {
	if len(isbn) != 10 {
		return false
	}

	soma := 0
	for i := 0; i < 9; i++ {
		digito, err := strconv.Atoi(string(isbn[i]))
		if err != nil {
			return false
		}
		soma += digito * (10 - i)
	}

	ultimoCaracter := isbn[9]
	var ultimoDigito int
	if ultimoCaracter == 'X' {
		ultimoDigito = 10
	} else {
		var err error
		ultimoDigito, err = strconv.Atoi(string(ultimoCaracter))
		if err != nil {
			return false
		}
	}

	soma += ultimoDigito
	return soma%11 == 0
}

func validarISBN13(isbn string) bool {
	if len(isbn) != 13 {
		return false
	}

	soma := 0
	for i := 0; i < 13; i++ {
		digito, err := strconv.Atoi(string(isbn[i]))
		if err != nil {
			return false
		}
		if i%2 == 0 {
			soma += digito
		} else {
			soma += digito * 3
		}
	}

	return soma%10 == 0
}
