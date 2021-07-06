import personaje.*
import enemigos.*
import nivelesycfg.*
import wollok.game.*
import clases.*

class Escalera {

	var property position

	method image() {
		return "escalera.png"
	}

	method recibirAtaque(danio) {
	}

	method recibirAtaque() {
	}

	method esEscalera() {
		return true
	}

	method esEscotilla() {
		return false
	}

	method pisosQueSube() {
		return 4
	}

	method esCannon() {
		return false
	}

	method teEncontro(objeto) {
	}

}

class EscaleraChica inherits Escalera {

	override method image() {
		return "escaleraChica.png"
	}

	override method pisosQueSube() {
		return 3
	}

}

class Escotilla {

	var property position

	method image() {
		return "escotilla.png"
	}

	method recibirAtaque(danio) {
	}

	method recibirAtaque() {
	}

	method esEscotilla() {
		return true
	}

	method esEscalera() {
		return false
	}

	method pisosQueBaja() {
		return 4
	}

	method esCannon() {
		return false
	}

	method teEncontro(objeto) {
	}

}

class EscotillaChica inherits Escotilla {

	override method pisosQueBaja() {
		return 3
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

class Cannon {

	var property image = "cannonUnloaded.png"
	var property estaCargado = false
	var property position

	method cargar() {
		game.say(self, "cargando...")
		personajePrincipal.tieneBala(false)
		personajePrincipal.actualizarImagen()
		game.schedule(3000, { =>
			self.estaCargado(true)
			self.image("cannonLoaded.png")
			game.say(self, "listo para disparar")
		})
	}

	method disparar() {
		if (self.estaCargado()) {
			cannonBall.lanzar(self)
			game.sound("cannonShot.mp3").play()
			self.descargar()
			self.image("cannonUnloaded.png")
		} else {
			game.say(personajePrincipal, "el cañon no esta cargado")
		}
	}

	method descargar() {
		self.estaCargado(false)
	}

	method cargarSiTieneBala() {
		if (personajePrincipal.tieneBala()) {
			self.cargar()
		} else {
			game.say(personajePrincipal, "no tengo bala para cargar")
		}
	}

	method teEncontro(objeto) {
	}

	method esCannon() {
		return true
	}

	method esEscalera() {
		return false
	}

	method esEscotilla() {
		return false
	}

	method recibirAtaque() {
	}

	method recibirAtaque(danio) {
	}

	method recibirDanio() {
	}

	method recibirDanio(cantidad) {
	}

}

object cajaDeBalas {

	var property image = "void.png"
	var property position = new MiPosicion(x = 1, y = 7)

	method teEncontro(objeto) {
	}

	method recibirDanio() {
	}

	method recibirDanio(cantidad) {
	}

	method esCannon() {
		return false
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

const barraDeVidaMC = new BarraDeVidaMC(personaje = personajePrincipal)

const pocionDeVida01 = new PocionDeVida(vidaQueRecupera = 25)

const pocionDeVida02 = new PocionDeVida(vidaQueRecupera = 25)

const escalera01 = new Escalera(position = new MiPosicion(x = 13, y = 1))

const escotilla01 = new Escotilla(position = new MiPosicion(x = 13, y = 5))

const escalera03 = new EscaleraChica(position = new MiPosicion(x = 5, y = 1))

const escalera04 = new EscaleraChica(position = new MiPosicion(x = 3, y = 4))

const escotilla03 = new EscotillaChica(position = new MiPosicion(x = 5, y = 4))

const escotilla04 = new EscotillaChica(position = new MiPosicion(x = 3, y = 7))

const cannon01 = new Cannon(position = new MiPosicion(x = 7, y = 1))

const cannon02 = new Cannon(position = new MiPosicion(x = 7, y = 4))

const cannon03 = new Cannon(position = new MiPosicion(x = 7, y = 7))

