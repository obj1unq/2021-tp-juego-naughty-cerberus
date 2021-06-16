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
	
	method recibirAtaque() {
		
	}

}

object escotilla {

	var property position = new MiPosicion(x = 13, y = 5)

	method image() {
		return "escotilla.png"
	}

	method teEncontro(personaje) {
	}

	method recibirAtaque() {
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

	method spawn(enemigo) {
		self.position(enemigo.position())
		game.addVisual(self)
	}

}



class BarraDeVidaMC  {
	
	const personaje 
	
	method position() = new MiPosicion(x = personaje.position().x(), y = personaje.position().y()+1)
	
    method image() {
		return if (personaje.vida()>0){"vida_" + "personajePrincipal" + self.cantDeVida().toString() + ".png"}			
				else {"void.png"}
	}

    method cantDeVida() {
		return ((personaje.vida() / 100).roundUp(1) * 100).max(0)
	}

}

class BarraDeVidaSpectrum  {
	
	const personaje
	
	method position() = new MiPosicion(x = personaje.position().x(), y = personaje.position().y()+1)
	
    method image() {
		return if(personaje.vida()>0){"vida_" + "spectrum" + self.cantDeVida().toString() + ".png"}
				else {"void.png"}	
	}
	
	 method cantDeVida() {
		return ((personaje.vida() / 500).roundUp(1) * 100).max(0)
	}

}

class BarraDeVidaOgre {
	
	const personaje

	method position() = new MiPosicion(x = personaje.position().x(), y = personaje.position().y()+2)
	
	method image() {
		return if(personaje.vida()>0){"vida_" + "ogre" + self.cantDeVida().toString() + ".png"}	
				else {"void.png"}
	}	
	
	method cantDeVida() {
		return ((personaje.vida() / 800).roundUp(1) * 100).max(0)
	}
	
}


const barraDeVidaMC = new BarraDeVidaMC(personaje = personajePrincipal)
const barraDeVidaSpectrum =new BarraDeVidaSpectrum(personaje = spectrum01)
const barraDeVidaOgre = new BarraDeVidaOgre(personaje = ogre01)
