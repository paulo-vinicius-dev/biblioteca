// +build testes
package testes

import (
	"fmt"
	"os"
)

type teste struct {
	funcao func(interface{})bool
	dado   interface{}
}


var (
	testes map[string]teste
	testesComFalha []string
	testesComSucesso []string
	testesParaPular []string
)

func init() {
	testes = make(map[string]teste, 0)
	testesComFalha = make([]string, 0)
	testesComSucesso = make([]string, 0)
	testesParaPular = make([]string, 0)
}

func DeclararTeste(nome string, funcao func(interface{})bool, dado interface{}) {
	_, jaTem := testes[nome]
	if jaTem {
		fmt.Printf("O teste '%s' já foi declarado.\n", nome)		
		os.Exit(1)
	}
		
	testes[nome] = teste{
		funcao: funcao,
		dado: dado,
	}
}

func IgnorarTeste(nome string) {
	testesParaPular = append(testesParaPular, nome)	
}


func Testar() {
	for nomeDoTeste, teste := range testes {
		devePular := false
		for _, nomeDoTesteParaPular := range testesParaPular {
			if nomeDoTeste == nomeDoTesteParaPular {
				devePular = true	
				break
			}
		}
		if devePular {
			break
		}
		resultado :=  teste.funcao(teste.dado)
		fmt.Printf("===============%s===============\n", nomeDoTeste)
		fmt.Printf("Resultado: ")
		if resultado {
			fmt.Println("Passou")
			testesComSucesso = append(testesComSucesso, nomeDoTeste)	
		} else {
			fmt.Println("Falhou")
			testesComFalha = append(testesComFalha, nomeDoTeste)	
		} 
		for i := 0; i < len(nomeDoTeste) + 30; i += 1 {
			fmt.Printf("=")
		}
		fmt.Printf("\n")
	}	
	
	fmt.Println("===============SUMÀRIO============")
	fmt.Println("Número de testes que passaram:", len(testesComSucesso))
	fmt.Println("Teste que passaram:", testesComSucesso);
	fmt.Println("Número de testes que falharam:", len(testesComFalha))
	fmt.Println("Teste que falharam:", testesComFalha);
	fmt.Println("==================================")
}

