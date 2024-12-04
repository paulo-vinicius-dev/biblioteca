package recuperarSenha

import (
	"biblioteca/banco"
	"math/rand"
	"time"
	"fmt"
	"biblioteca/servicos"
)

type recuperacao map[string]struct {
	tempoDaRecuperacao time.Time
	email string
}

var _recuperacao recuperacao

func init() {
	_recuperacao = make(recuperacao)
}

const _TEMPO_LIMITE_DA_RECUPERACAO_EM_STRING = "25m"

func verificaSeTempoDaRecuperacaoEValido(tempoDaRecuperacao time.Time) bool { // eu preciso da duração da sessão em DURATION
	limite, _ := time.ParseDuration(_TEMPO_LIMITE_DA_RECUPERACAO_EM_STRING)
	duracaoTempoDaRecuperacao := time.Since(tempoDaRecuperacao)
	return limite.Nanoseconds() > duracaoTempoDaRecuperacao.Nanoseconds()
}


func verificaSeRecuperacaoEValido(codigo string) bool {
	recuperacao, ok := _recuperacao[codigo]
	if(!ok) {
		return false
	}

	if(!verificaSeTempoDaRecuperacaoEValido(recuperacao.tempoDaRecuperacao)) {
		delete(_recuperacao, codigo)
		return false
	}

	return true
}

func gerarStringAleatoria() string {
	caracteres := "abcdefghijklmnopqrsutvwyxz0123456789"
	return fmt.Sprintf(
		"%v%v%v%v",
		caracteres[rand.Intn(len(caracteres))],
		caracteres[rand.Intn(len(caracteres))],
		caracteres[rand.Intn(len(caracteres))],
		caracteres[rand.Intn(len(caracteres))],
	);
}

func CriarCodigoDeRecuperacao(emailDoUsuario string) bool {
	if !banco.VerificaSeEmailPertenceAoUsuario(emailDoUsuario)  {
		return false
	}
	codigo := gerarStringAleatoria()
	recuperacao := _recuperacao[codigo]
	recuperacao.tempoDaRecuperacao = time.Now()
	recuperacao.email = emailDoUsuario
	_recuperacao[codigo] = recuperacao
	servicos.Enviar(emailDoUsuario, "Código de recuperação", "Código de recuperação: " + codigo)
	return true
}

func MudarSenha(codigo, novaSenha string) {
	if recuperacao, ok := _recuperacao[codigo]; ok {
		delete(_recuperacao, codigo)
		banco.AlterarSenha(recuperacao.email, novaSenha)
	}

}

