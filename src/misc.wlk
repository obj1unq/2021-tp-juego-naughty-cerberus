import personaje.*
import enemigos.*
import nivelesycfg.*
import wollok.game.*
import clases.*

object escalera {	
	var property position = new MiPosicion(x = 13, y = 1)
	
	method image() {
		return "escalera.png"
	}
	
	method teEncontro(personaje) {
		
	}
}

object escotilla {
	var property position = new MiPosicion(x = 13, y = 5)
	
	method image() {
	return "escotilla.png"
	}
	
	method teEncontro(personaje) {
		
	}
	method recibirAtaque(){}
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
	
	method spawn(enemigo) {
		self.position(enemigo.position())
		game.addVisual(self)
		
	}
}

class BarraDeVida{
	
	const personaje
		
	method position() = new MiPosicion(x = personaje.position().x(), y = personaje.position().y()+2)
	
	method image() { return "vida_" + personaje + self.cantDeVida().toString() + ".png"	}	
	
	method cantDeVida()
		
}

class BarraDeVidaMC inherits BarraDeVida {
	
	override method position() = new MiPosicion(x = 0, y = 9)
	
	override method cantDeVida() {
		return personaje.vida()/100.roundUp(1)*100
	}
}

class BarraDeVidaSpectrum inherits BarraDeVida {
	
	override method cantDeVida() {
		return personaje.vida()/500.roundUp(1)*100
	}
	
	override method image() { return "vida_" + "spectrum" + self.cantDeVida().toString() + ".png" }
}

const barraDeVidaMC = new BarraDeVidaMC (personaje=personajePrincipal)

const barraDeVidaSpectrum = new BarraDeVidaSpectrum (personaje=spectrum02)