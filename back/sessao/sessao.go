package sessao

import "math/rand"
import "time"


type Sessao map[uint64]time.Time

var _sessao Sessao


const _TEMPO_LIMITE_DA_SESSAO_EM_STRING = "8h"

const (
	VALIDO = iota// Está presente no hashmap e está dentro do limite de tempo 
	EXPIRADO // Está presente no hashmap no entanto está fora do limite do tempo
	INVALIDO //  Não está presente no hashmap 
)

func init() {
	_sessao = make(Sessao)	
}


func  verificaSeTempoDaSessaoEValido(tempoDaSessao time.Time) bool { // eu preciso da duração da sessão em DURATION
	limite, _ := time.ParseDuration(_TEMPO_LIMITE_DA_SESSAO_EM_STRING)
	duracaoTempoDaSessao := time.Since(tempoDaSessao)
	return limite.Nanoseconds() > duracaoTempoDaSessao.Nanoseconds()
	
}


func PegarSessaoAtual() Sessao {
	return _sessao
}

func VerificaSeIdDaSessaoEValido(idDaSessao uint64) int {
	if tempoDaSessao, ok := _sessao[idDaSessao]; ok {
		if(verificaSeTempoDaSessaoEValido(tempoDaSessao)) {
			return VALIDO
		}
		// Já que o tempo expirou vamos excluir essa sessão
		delete(_sessao, idDaSessao)
		return EXPIRADO
	}
	return INVALIDO
}

// OBS: o id zero vai ser reservado para quando o front não tenha um id 
func CriarNovaSessao() (uint64, bool) { // o bool e para dizer se foi possível criar ou não a sessão
	novaSessao := rand.Uint64()
	if VerificaSeIdDaSessaoEValido(novaSessao) == INVALIDO  && novaSessao != 0 {
		_sessao[novaSessao] = time.Now()
		return novaSessao, true
	}
	return 0, false
}
