package main

import (
	_ "embed"

	"instalador/ui"

	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/app"
)

//go:embed frontback.zip
var FrontBack []byte

//go:embed bd.tar.gz
var BANCO []byte

//go:embed script.sql
var SCRIPT []byte

//go:embed .env
var ENV []byte

func main() {
	a := app.New()
	janela := a.NewWindow("Palasys")
	janela.Resize(fyne.NewSize(640, 480))
	contexto := ui.ContextoUi{
		Janela:    janela,
		FrontBack: FrontBack,
		Banco:     BANCO,
		Script:    SCRIPT,
		Env:       ENV,
	}
	ui.PrimeiraTela(contexto)

	janela.ShowAndRun()

}
