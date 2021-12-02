import wollok.game.*
import clases.*

object abc {
	
	
}
// se asigna cada letra a su respectiva imagen, y para crear textos se haria de la siguiente forma:


object creadorDeTexto{
	
	method dibujarTexto(personaje,texto){
		game.addVisual(dialogBox)
		convertidorDeTextoALista.convertir(texto)
	}
}

object convertidorDeTextoALista{
	// recibe un string y lo separa una lista de letras por separada 
	// que luego serán re-creadas como objetos visualmente en la pantalla
	method convertir(texto){
		
	}
}

object dialogBox {

	var property position = new MiPosicion(x = 0, y = 0)

	method image() {
		return "dialog.png"
	}

	method configurarDialogo() {
		keyboard.enter().onPressDo({ //TODO 
									})
	}

	method teEncontro(objeto) {
	}

	method recibirAtaque() {
	}

	method recibirAtaque(danio) {
	}

}