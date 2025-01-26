package ui

import "fyne.io/fyne/v2"

type ContextoUi struct {
	FrontBack           []byte
	Banco               []byte
	Script              []byte
	Env                 []byte
	Janela              fyne.Window
	Passo               int
	CaminhoDaInstalacao string
}
