package ui

import (
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/layout"
	"fyne.io/fyne/v2/widget"
)

func Termos(contexto ContextoUi) {
	termos := `
	Os termos dessa aplicação são muito sérios.
	Você deveria ler eles com cuidado.
	:)
	`

	parteDeBaixo := container.New(
		layout.NewGridLayoutWithColumns(3),
		layout.NewSpacer(),
		layout.NewSpacer(),
		container.New(
			layout.NewGridLayoutWithRows(3),
			layout.NewSpacer(),
			layout.NewSpacer(),
			widget.NewButton("Aceitar e Proseguir", func() {
				Localicao(contexto)
			}),
		),
	)
	gridTermos := widget.NewTextGridFromString(termos)

	//resposta := binding.NewBool()
	//aceite.Bind(resposta)
	conteudoPrincipal := container.New(
		layout.NewGridLayoutWithRows(3),
		widget.NewLabel("Termos de uso:"),
		gridTermos,
		parteDeBaixo,
	)

	contexto.Janela.SetContent(conteudoPrincipal)
}
