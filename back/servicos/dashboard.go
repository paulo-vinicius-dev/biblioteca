package servicos

import "biblioteca/banco"
import "biblioteca/modelos"
import "time"


func PegarDashboard() modelos.Dashboard {
	dash := banco.PegarDashboard()
	devolucoesAtrasadosSemana := banco.PegarQtdDevolucoesAtrasadoSemana()
	for i := int(time.Now().Weekday()) - 1; i >= 0; i -= 1 {
		dash.QtdLivrosAtrasadosSemana[i] = dash.QtdLivrosAtrasadosSemana[i + 1] + devolucoesAtrasadosSemana[i]
	}
	return dash
}
