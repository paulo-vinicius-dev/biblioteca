package rotas

//import "biblioteca/modelos"
import "biblioteca/servicos"
import "net/http"
import "fmt"

func erroServicoExemplarParaErroHttp(erro servicos.ErroServicoExemplar, resposta http.ResponseWriter) {
	switch(erro){
	case servicos.ErroServicoExemplarLivroInexistente:
		resposta.WriteHeader(http.StatusNotFound)
		fmt.Fprintf(resposta, "Livro não encontrado")
	case servicos.ErroServicoExemplarStatusInvalido:
		fallthrough
	case servicos.ErroServicoExemplarEstadoInvalido:
		resposta.WriteHeader(http.StatusBadRequest)
		fmt.Fprintf(resposta, "Requisão para a rota de exemplar mau feito")
	case servicos.ErroServicoExemplarMudouLivro:
		resposta.WriteHeader(http.StatusForbidden)
		fmt.Fprintf(resposta, "Não é possível mudar o livro do exemplar")
	case servicos.ErroServicoExemplarExemplarInexistente:
		resposta.WriteHeader(http.StatusNotFound)
		fmt.Fprintf(resposta, "Exemplar não encontrado")
	case servicos.ErroServicoExemplarSemPermissao:
		resposta.WriteHeader(http.StatusForbidden)
		fmt.Fprintf(resposta, "Não é possível mudar o livro do exemplar")
	}
}

type ViewExemplarLivro struct {
	IdDoExemplarLivro int
	Cativo        bool
	Status        int 
	Estado        int
	Ativo         bool
	IdDoLivro     int
	Isbn          string
	Titulo        string
	AnoPublicacao string
	Editora       string
	IdDoPais      int
	NomePais      string
	SiglaPais     string
}




type RespostaLivro struct {
	exemplares []ViewExemplarLivro
}

type RequisicaoExemplar struct {
	IdDoUsuario       int
	IdDoExemplarLivro int
	Livro             int
	Cativo            bool
	Status            int
	Estado            int
	Ativo             bool
}
