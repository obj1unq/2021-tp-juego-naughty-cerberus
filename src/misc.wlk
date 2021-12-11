import personaje.*
import enemigos.*
import nivelesycfg.*
import wollok.game.*
import clases.*

class Escalera inherits ObjetosInteractuables{

	var property position

	method image() {
		return "escalera.png"
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

	override method subir(objeto){
		self.irAlPisoDeArriba(objeto)
	}
	method irAlPisoDeArriba(objeto) {
		objeto.actualizarPosicion(new MiPosicion(x = self.position().x(), y = self.position().y() + self.pisosQueSube()))
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

class Escotilla inherits ObjetosInteractuables{

	var property position

	method image() {
		return "escotilla.png"
	}


	method pisosQueBaja() {
		return 4
	}

	method esCannon() {
		return false
	}

	override method bajar(objeto){
		self.irAlPisoDeAbajo(objeto)
	}
	
	method irAlPisoDeAbajo(objeto) {
		objeto.actualizarPosicion(new MiPosicion(x = self.position().x(), y = self.position().y() - self.pisosQueBaja()))
	}
}

class EscotillaChica inherits Escotilla {

	override method pisosQueBaja() {
		return 3
	}

}

class PocionDeVida inherits ObjetosInteractuables{

	var property vidaQueRecupera
	var property position = game.origin()

	method image() {
		return "pocionDeVida.png"
	}

	override method teEncontro(personaje) {
		personaje.vida((personaje.vida() + vidaQueRecupera).min(100))
		game.removeVisual(self)
		game.sound("pocion-sfx.mp3").play()
	}

	method spawn(enemigo) {
		self.position(enemigo.position())
		game.addVisual(self)
	}

}

class Cannon inherits ObjetosInteractuables{

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
		self.verificarQueEstaCargado()
		cannonBall.lanzar(self)
		game.sound("cannonShot.mp3").play()
		self.descargar()
		self.image("cannonUnloaded.png")
	}

	method verificarQueEstaCargado() {
		if (!self.estaCargado()) {
			game.say(personajePrincipal, "el cañon no esta cargado")
			game.error("")
		}
	}

	method descargar() {
		self.estaCargado(false)
	}

	method cargarSiTieneBala() {
		if (personajePrincipal.tieneBala()) {
			self.cargar()
			personajePrincipal.nombre("personaje")
			personajePrincipal.actualizarImagen()
		} else {
			game.say(personajePrincipal, "no tengo bala para cargar")
		}
	}

	override method interactuar(){
		if(!self.estaCargado()){
			self.cargarSiTieneBala()
		}
		else{
			self.disparar()
		}
		
	}

}

object cajaDeBalas inherits ObjetosInteractuables{

	var property image = "void.png"
	var property position = new MiPosicion(x = 1, y = 7)

	override method interactuar(){
		personajePrincipal.agarrarBala()
	}

}


class  BarraDe inherits ObjetosInteractuables{
	
	const usuario = null
	
	method getUsuario(){
		return usuario
	}
	method position() = new MiPosicion(x = self.getUsuario().position().x(), y = self.getUsuario().position().y() + 1)

	method image() {
		return if (self.condicionDeVida()) {
			self.textoNombreConVida() + self.cantDeVida().toString() + ".png"
		} else {
			self.textoSinVida()
		}
	}

	method cantDeVida() {
		return ((self.getStat() / 100).roundUp(1) * 100).max(0)
	}
	method getStat() {
		return self.getUsuario().vida()
	}
	method textoSinVida() {
		return "void.png"
	}
	method textoNombreConVida() {
		return "vida_" + self.getUsuario().toString()
	}
	method condicionDeVida() {
		return self.getUsuario().vida() > 0
	}

}

object barraDeEnergiaMC inherits BarraDe{
	
	override method getUsuario(){
		return personajePrincipal
	}

	override method textoSinVida() {
		return "energia_personajePrincipal0.png"
	}
	override method textoNombreConVida() {
		return "energia_" + self.getUsuario().toString()
	}
	override method condicionDeVida() {
		return self.getUsuario().energia() > 0
	}
	override method cantDeVida() {
		return ((self.getUsuario().energia() / 100).roundUp(1) * 100).max(0)
	}

}

class BarraDeVidaEnemigo inherits BarraDe{


	override method position() = new MiPosicion(x = self.getUsuario().position().x(), y = self.getUsuario().position().y() + self.posicionExtra())

	override method textoNombreConVida() {
		return "vida_enemigo_"
	}
	
	override method cantDeVida() { 
		return ((self.getUsuario().vida() / self.vidaInicial().max(1)).roundUp(1) * 100).max(0) / 10
	}

	method vidaInicial() {
		return self.getUsuario().vidaInicial()
	}

	method posicionExtra() {
		return self.getUsuario().posicionBarra()
	}
}

object errorReporter {

	var property position = new MiPosicion(x = 22, y = 20)
	var property image = "void.png"

}


// BarraMC

const barraDeVidaMC = new BarraDe(usuario = personajePrincipal)


// Pociones

const pocionDe15 = new PocionDeVida(vidaQueRecupera = 15)

const pocionDe20 = new PocionDeVida(vidaQueRecupera = 20)

const pocionDe25 = new PocionDeVida(vidaQueRecupera = 25)

const pocionDe30 = new PocionDeVida(vidaQueRecupera = 30)

//pantalla 1
const escalera01 = new Escalera(position = new MiPosicion(x = 15, y = 1))

const escotilla01 = new Escotilla(position = new MiPosicion(x = 15, y = 5))

//pantalla 2
const escalera02 = new Escalera(position = new MiPosicion(x = 11, y = 1))

const escotilla02 = new Escotilla(position = new MiPosicion(x = 11, y = 5))

//pantalla 3
const escalera03 = new Escalera(position = new MiPosicion(x = 15, y = 4))

const escotilla03 = new Escotilla(position = new MiPosicion(x = 15, y = 8))

const escalera04 = new Escalera(position = new MiPosicion(x = 3, y = 0))

const escotilla04 = new Escotilla(position = new MiPosicion(x = 3, y = 4))

//pantalla dragon
const escalera05 = new EscaleraChica(position = new MiPosicion(x = 5, y = 1))

const escalera06 = new EscaleraChica(position = new MiPosicion(x = 3, y = 4))

const escotilla05 = new EscotillaChica(position = new MiPosicion(x = 5, y = 4))

const escotilla06 = new EscotillaChica(position = new MiPosicion(x = 3, y = 7))

const cannon01 = new Cannon(position = new MiPosicion(x = 7, y = 1))

const cannon02 = new Cannon(position = new MiPosicion(x = 7, y = 4))

const cannon03 = new Cannon(position = new MiPosicion(x = 7, y = 7))