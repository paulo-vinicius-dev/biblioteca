package main

import (
	_ "embed"

	"instalador/ui"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
)

//go:embed 001.zip
var BackFront []byte

//go:embed bd.tar.gz
var BANCO []byte

//go:embed script.sql
var SCRIPT []byte

func main() {
	a := app.New()
	janela := a.NewWindow("Palasys")
	janela.Resize(fyne.NewSize(640, 480))
	contexto := ui.ContextoUi{
		Janela:    janela,
		Backfront: BackFront,
		Banco:     BANCO,
		Script:    SCRIPT,
	}
	ui.PrimeiraTela(contexto)

	janela.ShowAndRun()

}
