package ui

import (
	"fmt"
	"io"
	"os"
	"path"

	"archive/zip"

	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/layout"
	"fyne.io/fyne/v2/widget"
)

const (
	EXTRAINDO_ARQUIVOS = iota
	INICIALIZAR_BANCO_DE_DADOS
	COPIAR_ENV
)

func extrair(contexto ContextoUi) {
	erro := os.MkdirAll(path.Join(contexto.CaminhoDaInstalacao, "pallasys"), 0777)
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}

	frontback, erro := os.Create(path.Join(contexto.CaminhoDaInstalacao, "frontback.zip"))
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}
	defer frontback.Close()
	frontback.Write(contexto.FrontBack)
	descompresor_zip, erro := zip.OpenReader(path.Join(contexto.CaminhoDaInstalacao, "frontback.zip"))
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}
	defer descompresor_zip.Close()

	for _, arquivo := range descompresor_zip.File {
		leitor, erro := arquivo.Open()
		if erro != nil {
			fmt.Println(erro)
			os.Exit(1)
		}
		defer leitor.Close()
		novoCaminho := path.Join(contexto.CaminhoDaInstalacao, arquivo.Name)

		if arquivo.FileInfo().IsDir() {
			erro := os.MkdirAll(novoCaminho, 0777)
			if erro != nil {
				fmt.Println(erro)
				os.Exit(1)
			}
			continue
		}

		descomprimido, erro := os.Create(novoCaminho)
		defer descomprimido.Close()
		if erro != nil {
			fmt.Println(erro)
			os.Exit(1)
		}
		_, erro = io.Copy(descomprimido, leitor)
		if erro != nil {
			fmt.Println(erro)
			os.Exit(1)
		}
	}

	contexto.Passo = INICIALIZAR_BANCO_DE_DADOS
	Principal(contexto)
}

func Principal(contexto ContextoUi) {
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
	progresso := widget.NewProgressBar()
	progresso.Max = float64(COPIAR_ENV)
	progresso.Value = float64(contexto.Passo)

	switch contexto.Passo {
	case EXTRAINDO_ARQUIVOS:
		go extrair(contexto)
	}

	conteudoPrincipal := container.New(
		layout.NewGridLayoutWithRows(3),
		layout.NewSpacer(),
		container.New(
			layout.NewGridLayoutWithRows(2),
			widget.NewLabel("Progresso:"),
			progresso,
		),
		parteDeBaixo,
	)

	contexto.Janela.SetContent(conteudoPrincipal)
}
