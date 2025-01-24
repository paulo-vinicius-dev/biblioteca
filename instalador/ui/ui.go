package ui

import "fyne.io/fyne/v2"

type ContextoUi struct {
	Backfront           []byte
	Banco               []byte
	Script              []byte
	Janela              fyne.Window
	Passo               int
	CaminhoDaInstalacao string
}
