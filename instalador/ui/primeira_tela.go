package ui

import (
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/layout"
	"fyne.io/fyne/v2/widget"
)

func PrimeiraTela(contexto ContextoUi) {
	parteDeBaixo := container.New(
		layout.NewGridLayoutWithColumns(3),
		layout.NewSpacer(),
		layout.NewSpacer(),
		container.New(
			layout.NewGridLayoutWithRows(3),
			layout.NewSpacer(),
			layout.NewSpacer(),
			widget.NewButton("Próximo", func() {
				Termos(contexto)
			}),
		),
	)
	conteudoPrincipal := container.New(
		layout.NewGridLayoutWithRows(3),
		layout.NewSpacer(),
		widget.NewLabel("Seja bem-vindo(a) Palasys. Por favor clique em próximo para seguir na instalação."),
		parteDeBaixo,
	)

	contexto.Janela.SetContent(conteudoPrincipal)
}
