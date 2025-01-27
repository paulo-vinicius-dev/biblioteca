package ui

import (
	"fmt"
	"io"
	"os"
	"os/exec"
	"path"
	"regexp"
	"runtime"
	"strings"

	"archive/zip"

	"fyne.io/fyne/v2/container"
	"fyne.io/fyne/v2/layout"
	"fyne.io/fyne/v2/widget"
	"github.com/joho/godotenv"
	"github.com/walle/targz"
)

const (
	EXTRAINDO_ARQUIVOS = iota
	COPIAR_ENV
	INICIALIZAR_BANCO_DE_DADOS
	TERMINADO
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
		if erro != nil {
			fmt.Println(erro)
			os.Exit(1)
		}
		defer descomprimido.Close()

		_, erro = io.Copy(descomprimido, leitor)
		if erro != nil {
			fmt.Println(erro)
			os.Exit(1)
		}
	}

	bdtargz, erro := os.Create(path.Join(contexto.CaminhoDaInstalacao, "bd.tar.gz"))
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}
	_, erro = bdtargz.Write(contexto.Banco)
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}
	bdtargz.Close()
	erro = targz.Extract(path.Join(contexto.CaminhoDaInstalacao, "bd.tar.gz"), path.Join(contexto.CaminhoDaInstalacao, "pallasys"))
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}

	dir, erro := os.Open(path.Join(contexto.CaminhoDaInstalacao, "pallasys"))
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}
	defer dir.Close()
	entradasDoDiretorio, erro := dir.ReadDir(0)
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}
	// estamos procurando a pasta do banco para renomearmos
	for _, entrada := range entradasDoDiretorio {
		if entrada.IsDir() && strings.Index(entrada.Name(), "postgres") == 0 {
			erro = os.Rename(path.Join(contexto.CaminhoDaInstalacao, "pallasys", entrada.Name()), path.Join(contexto.CaminhoDaInstalacao, "pallasys", "postgres"))
			if erro != nil {
				fmt.Println(erro)
				os.Exit(1)
			}
			break
		}
	}

	os.RemoveAll(path.Join(contexto.CaminhoDaInstalacao, "bd.tar.gz"))
	os.RemoveAll(path.Join(contexto.CaminhoDaInstalacao, "frontback.zip"))

	contexto.Passo = COPIAR_ENV
	Principal(contexto)

}

func inicializar(contexto ContextoUi) {
	fmt.Println("Inicializando")
	caminhoBinarioPostgres := path.Join(contexto.CaminhoDaInstalacao, "pallasys", "postgres", "bin")
	caminhoPastaBanco := path.Join(contexto.CaminhoDaInstalacao, "pallasys", "postgres", "banco")
	erro := os.MkdirAll(caminhoPastaBanco, 0777)
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}

	texto := "postgres://postgres@localhost:5432/postgres?options=-c%20search_path%3DBIBLIOTECA"

	regexNomeUsuario := regexp.MustCompile(`//([^@]+)@`)
	var nomeUsuario string

	match := regexNomeUsuario.FindStringSubmatch(texto)
	if len(match) > 1 {
		nomeUsuario = match[1]
	} else {
		fmt.Println("Não achou o nome do usuário ")
		os.Exit(1)
	}

	var comandoInicializador *exec.Cmd
	if runtime.GOOS == "windows" {
		fmt.Printf("vai no windows certo")
		comandoInicializador = exec.Command(
			"powershell",
			path.Join(caminhoBinarioPostgres, "initdb.exe"),
			fmt.Sprintf("--username=%s", nomeUsuario),
			"--encoding=UTF8",
			"--locale=en",
			"--lc-collate=C", // mudar para pt br? Eu coloquei assim porque é como está no script do scoop
			// e sei que o projeto roda com essas configs
			fmt.Sprintf("-D %s", caminhoPastaBanco),
		)
	} else {
		comandoInicializador = exec.Command(
			path.Join(caminhoBinarioPostgres, "initdb"),
			fmt.Sprintf("--username=%s", nomeUsuario),
			"--encoding=UTF8",
			"--locale=en",
			"--lc-collate=C",
			fmt.Sprintf("-D %s", caminhoPastaBanco),
		)
	}

	saida, erro := comandoInicializador.Output()
	fmt.Println(string(saida))

	if runtime.GOOS == "windows" {
		erro = exec.Command(

			path.Join(caminhoBinarioPostgres, "pg_ctl.exe"),
			"start",
		).Start()
	} else {
		erro = exec.Command(
			path.Join(caminhoBinarioPostgres, "pg_ctl"),
			"start",
		).Start()
	}

	if erro != nil {
		fmt.Println("Não foi possível startar o servidor")
		fmt.Println(erro)
		os.Exit(1)
	}
	caminhoScript := path.Join(caminhoPastaBanco, "script.sql")
	script, _ := os.Create(caminhoScript)
	script.Write(contexto.Script)
	script.Close()

	nomeBanco := os.Getenv("DB_URL")[strings.LastIndex(os.Getenv("DB_URL"), "%3D"):]

	if runtime.GOOS == "windows" {
		erro = exec.Command(
			"powershell",
			path.Join(caminhoBinarioPostgres, "psql.exe"),
			fmt.Sprintf("-U %s", nomeUsuario),
			fmt.Sprintf("-U %s", nomeBanco),
			fmt.Sprintf("-a -f %s", caminhoScript),
			`-c '\q'`,
		).Start()
	} else {
		erro = exec.Command(
			path.Join(caminhoBinarioPostgres, "psql"),
			fmt.Sprintf("-U %s", nomeUsuario),
			fmt.Sprintf("-U %s", nomeBanco),
			fmt.Sprintf("-a -f %s", caminhoScript),
			`-c '\q'`,
		).Start()
	}

	if erro != nil {
		fmt.Println("falha ao executar o script")
		fmt.Println(erro)
		os.Exit(1)
	}

	// conexao, erro := pgx.Connect(context.Background(), os.Getenv("DB_URL"))
	// if erro != nil {
	// 	fmt.Println(erro)
	// 	os.Exit(1)
	// }

	// if _, erro := conexao.Exec(context.Background(), string(contexto.Script)); erro != nil {
	// 	fmt.Println(erro)
	// 	os.Exit(1)
	// }

	if runtime.GOOS == "windows" {
		erro = exec.Command(

			path.Join(caminhoBinarioPostgres, "pg_ctl.exe"),
			"stop",
		).Start()
	} else {
		erro = exec.Command(
			path.Join(caminhoBinarioPostgres, "pg_ctl"),
			"stop",
		).Start()
	}

	if erro != nil {
		fmt.Println("Não foi possível sair do servidor")
		fmt.Println(erro)
		os.Exit(1)
	}

	fmt.Println("terminou")

	contexto.Passo = TERMINADO
	Principal(contexto)
}

func copiarEnv(contexto ContextoUi) {
	env, erro := os.Create(path.Join(contexto.CaminhoDaInstalacao, "pallasys", ".env"))
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}
	_, erro = env.Write(contexto.Env)
	if erro != nil {
		fmt.Println(erro)
		os.Exit(1)
	}
	env.Close()

	godotenv.Load(path.Join(contexto.CaminhoDaInstalacao, "pallasys", ".env"))

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
	progresso.Max = float64(TERMINADO)
	progresso.Value = float64(contexto.Passo)

	switch contexto.Passo {
	case EXTRAINDO_ARQUIVOS:
		go extrair(contexto)
	case COPIAR_ENV:
		go copiarEnv(contexto)
	case INICIALIZAR_BANCO_DE_DADOS:
		go inicializar(contexto)

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
