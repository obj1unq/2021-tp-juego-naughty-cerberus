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

	method recibirAtaque(danio) {
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

	method recibirAtaque(danio) {
	}

}

class PocionDeVida {

	var property vidaQueRecupera
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

	method recibirAtaque() {
	}

	method recibirAtaque(danio) {
	}

}

class BarraDeVidaMC {

	const personaje

	method position() = new MiPosicion(x = personaje.position().x(), y = personaje.position().y() + 1)

	method image() {
		return if (personaje.vida() > 0) {
			"vida_" + "personajePrincipal" + self.cantDeVida().toString() + ".png"
		} else {
			"void.png"
		}
	}

	method cantDeVida() {
		return ((personaje.vida() / 100).roundUp(1) * 100).max(0)
	}

	method recibirAtaque() {
	}

	method recibirAtaque(danio) {
	}

}

class BarraDeVidaEnemigo {

	const property enemigo

	method position() = new MiPosicion(x = enemigo.position().x(), y = enemigo.position().y() + self.posicionExtra())

	method image() { // corregir aca,el problema es que la vida del enemigo debe estar convertida en % y falta eso.
		return if (enemigo.vida() > 0) {
			"vida_enemigo_" + self.cantDeVida().toString() + ".png"
		} else {
			"void.png"
		}
	}

	method cantDeVida() { // hay que hacer que cantDeVida lo convierta en % y luego lo divida por 10
		return ((enemigo.vida() / self.vidaInicial().max(1)).roundUp(1) * 100).max(0) / 10
	}

	method vidaInicial() {
		return enemigo.vidaInicial()
	}

	method posicionExtra() {
		return enemigo.posicionBarra()
	}

	method recibirAtaque() {
	}

	method recibirAtaque(danio) {
	}

	method teEncontro(personaje) {
	}

}

/* Por que clases para la barras de vida del mc? 
 *  No se podrian parametrizar las barras de vida de los enemigos? 
 *  Se podria dar como parametro al inicializar la posicion "extra" que se le debe añadir a Y()
 Si quieren pueden hacerlo,sino lo hago yo despues - Braian */
const barraDeVidaMC = new BarraDeVidaMC(personaje = personajePrincipal)

//const ogre01barra = new BarraDeVidaEnemigo(enemigo = ogre01)//enemigo = ogre01
const spectrum01barra = new BarraDeVidaEnemigo(enemigo = spectrum01) //enemigo = spectrum01
//const barraDeVidaSpectrum = new BarraDeVidaSpectrum(personaje = spectrum01)

const wolf01barra = new BarraDeVidaEnemigo(enemigo = wolf01)

const pocionDeVida01 = new PocionDeVida(vidaQueRecupera = 25)

const pocionDeVida02 = new PocionDeVida(vidaQueRecupera = 25)

