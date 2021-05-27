import personaje.*
import enemigos.*
import nivelesycfg.*
import wollok.game.*

object escalera {	
	var property position = game.at(17,1)
	
	method image() {
		return "escalera.png"
	}
	
	method teEncontro(personaje) {
		
	}
}

object escotilla {
	var property position = game.at(17, 5)
	
	method image() {
	return "escotilla.png"
	}
	
	method teEncontro(personaje) {
		
	}
}


object pocionDeVida {
	var property vidaQueRecupera = 25
	var property position = game.origin()
	
	method image() {
		return "pocionDeVida.png"
	}
	
	method teEncontro(personaje) {
		personaje.vida((personaje.vida() + vidaQueRecupera).min(100))  
		game.removeVisual(self)
		game.sound("pocion-sfx.mp3").play()
		
	}
}