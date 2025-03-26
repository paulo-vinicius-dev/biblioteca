package modelos

type Emprestimo struct {
	IdDoEmprestimo        int
	Exemplar              Exemplar
	Usuario               Usuario
	DataEmprestimo        string
	NumeroRenovacoes      int
  DataDeEntregaPrevista string
	DataDeDevolucao       string
	Status                int
}
