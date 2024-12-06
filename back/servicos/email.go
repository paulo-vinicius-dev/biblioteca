package servicos

import (
	"os"
	"log"
	"net/smtp"
)

var email string
var senhaEmail string

func InicializarServicoEmail() {
	email = os.Getenv("EMAIL")
	senhaEmail = os.Getenv("SENHA_EMAIL")
}


func Enviar(para, assunto ,corpo string) {

	msg := "From: " + email + "\n" +
		"To: " + para + "\n" +
		"Subject: " +  assunto + "\n\n" +
		corpo

	err := smtp.SendMail("smtp.gmail.com:587",
		smtp.PlainAuth("", email, senhaEmail, "smtp.gmail.com"),
		para, []string{para}, []byte(msg))

	if err != nil {
		log.Printf("smtp error: %s", err)
		return
	}
	
	log.Print("Email enviado")
}