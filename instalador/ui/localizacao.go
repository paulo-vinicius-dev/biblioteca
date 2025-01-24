package ui

import (
	"fyne.io/fyne/v2"
	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/data/binding"
	"fyne.io/fyne/v2/dialog"
	"fyne.io/fyne/v2/layout"
	"fyne.io/fyne/v2/widget"
)

var caminho binding.String = nil

func Localicao(contexto ContextoUi) {
	if caminho == nil {
		caminho = binding.NewString()
	}

	proximo := widget.NewButton("Próximo", func() {

	})
	if contexto.CaminhoDaInstalacao == "" {
		proximo.Disable()
	}
	parteDeBaixo := container.New(
		layout.NewGridLayoutWithColumns(3),
		layout.NewSpacer(),
		layout.NewSpacer(),
		container.New(
			layout.NewGridLayoutWithRows(3),
			layout.NewSpacer(),
			layout.NewSpacer(),
			proximo,
		),
	)
	conteudoPrincipal := container.New(
		layout.NewGridLayoutWithRows(3),
		widget.NewLabel("Por favor procure o caminho de instalação do programa"),
		container.New(
			layout.NewGridLayoutWithRows(2),
			widget.NewLabel("Caminho da instalação:"),
			container.New(
				layout.NewGridLayoutWithColumns(2),
				widget.NewEntryWithData(caminho),
				widget.NewButton("Procurar", func() {
					dialog.ShowFolderOpen(func(pasta fyne.ListableURI, erro error) {
						if erro != nil {
							caminho.Set(pasta.Path())
							contexto.CaminhoDaInstalacao = pasta.Path()
							Localicao(contexto)
						}
					},
						contexto.Janela)
				}),
			),
		),
		parteDeBaixo,
	)

	contexto.Janela.SetContent(conteudoPrincipal)
}
