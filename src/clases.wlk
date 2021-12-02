import personaje.*
import wollok.game.*
import nivelesycfg.*
import menus.*

class Mode {

	var property speedFrame // la velocidad de animacion de los frames(en ms)
	var property totalImg // la cantidad total de imagenes(cantidad de frames)
	var property time // el comienzo del conteo de cantidad de img
	var property accion // el tipo de accion que realizará: (Run,Die,Attack,Dodge)

	method realizarAccion(objeto, direccion) {
		objeto.sigueEnAccion(true)
		self.timeLapse(objeto)
		imageNameConversor.getImgName(objeto, accion, direccion, self.time().toString()) // direccion(derecha o izquierda) hacia donde hará la animacion
		if (self.time() == totalImg) {
			game.removeTickEvent(accion)
			time = 0
			objeto.sigueEnAccion(false)
			game.schedule(500, { => objeto.standPositionImage()})
		}
	} 
	

	method accion(objeto, direccion) { // el llamado principal (el q comienza a ejecutar el resto de metodos de animacion)
		game.onTick(speedFrame, accion, {=> self.realizarAccion(objeto, direccion)})
	}

	method timeLapse(objeto) {
		time += 1
	}

}
// Se podria unificar los runMode del MC y el lobo creando una clase Run que herede Mode y que el movimiento lo haga segun direccion.Move(),y que segun la direccion dada se moviera para donde quisiera donde instancies
class Run inherits Mode {
	override method timeLapse(objeto) {
		time += 1
		objeto.direccion().move(objeto, 0.25)
	}

}
const runModeMC = new Run(accion = "Run", speedFrame = 30, totalImg = 4, time = 0)
const runModeWolf = new Run(accion = "Run", speedFrame = 45, totalImg = 4, time = 0)

/*
//object runModeL inherits Mode(accion = "Run", speedFrame = 30, totalImg = 4, time = 0) {
//
//	override method timeLapse(objeto) {
//		time += 1
//		left.move(objeto, 0.25)
//	// objeto.position().x(objeto.position().x() - 0.25)
//	}
//
//}
//
//object runModeR inherits Mode(accion = "Run", speedFrame = 30, totalImg = 4, time = 0) {
//
//	override method timeLapse(objeto) {
//		time += 1
//		right.move(objeto, 0.25)
//	// objeto.position().x(objeto.position().x() + 0.25)
//	}
//
//}
//
//object runModeWolfL inherits Mode(accion = "Run", speedFrame = 45, totalImg = 4, time = 0) {
//
//	override method timeLapse(objeto) {
//		time += 1
//		left.move(objeto, 0.25)
//	}
//
//}
//
//object runModeWolfR inherits Mode(accion = "Run", speedFrame = 45, totalImg = 4, time = 0) {
//
//	override method timeLapse(objeto) {
//		time += 1
//		right.move(objeto, 0.25)
//	}
//
//}
 */

object runModeDragonU inherits Mode(accion = "flight", speedFrame = 50, totalImg = 4, time = 0) {

	override method timeLapse(objeto) {
		time += 1
		objeto.position().y(objeto.position().y() + 0.25)
	}

}

object runModeDragonD inherits Mode(accion = "flight", speedFrame = 50, totalImg = 4, time = 0) {

	override method timeLapse(objeto) {
		time += 1
		objeto.position().y(objeto.position().y() - 0.25)
	}

}

class AttackMC inherits Mode { //quiza luego este attackMC se convierta en un attack generico para los melee??

	override method realizarAccion(objeto, direccion) {
		// objeto.image(direccion.imagenPersonajeAttack(objeto.portador().nombre())) usando algo así como esto
		personajePrincipal.image(direccion.imagenPersonajeAttack(personajePrincipal.nombre()))
		self.timeLapse(objeto)
		imageNameConversor.getImgName(objeto, accion, direccion, self.time().toString()) // direccion(derecha o izquierda) hacia donde hará la animacion
		if (self.time() == totalImg) {
			game.removeTickEvent(accion)
			time = 0
			game.schedule(500, { =>
				personajePrincipal.image(direccion.imagenPersonajeStand(personajePrincipal.nombre()))
				objeto.image("sword_void.png")
			})
		}
//		objeto.image(direccion.imagenPersonajeAttack(personajePrincipal.nombre()))
//		super(objeto,direccion)
//		game.removeVisual(objeto)
	}

//	override method accion(objeto, direccion) {
//		direccion.espadaMCPosition()
//		super(objeto, direccion)
//	}
}

const attackMode = new AttackMC(accion = "Attack", speedFrame = 65, totalImg = 3, time = 0)

//const enemigoAtacarADistancia = new Mode(accion = "AttackDistance",speedFrame = 65, totalImg = 3, time=0)
//const enemigoAtacarAAMelee = new Mode(accion = "AttackMelee",speedFrame = 65, totalImg = 3, time=0)
//const dodgeMode = new Mode(accion = "Dodge", speedFrame = 65, totalImg = 3, time = 0)
const dieModeMC = new Mode(accion = "Die", speedFrame = 60, totalImg = 3, time = 0)

class MiPosicion {

	var property x = 0
	var property y = 0

	/**
	 * Returns a new Position n steps right from this one.
	 */
	method right(n) = new MiPosicion(x = x + n, y = y)

	/**
	 * Returns a new Position n steps left from this one.
	 */
	method left(n) = new MiPosicion(x = x - n, y = y)

	/**
	 * Returns a new Position n steps up from this one.
	 */
	method up(n) = new MiPosicion(x = x, y = y + n)

	/**
	 * Returns a new Position, n steps down from this one.
	 */
	method down(n) = new MiPosicion(x = x, y = y - n)

}

class Teleport {

	var property xTP
	var property yTP
	var property pantallaNueva = pantalla1
	var property posX
	var property posY
	var property image = "void.png"

	method position() = new Position(x = xTP, y = yTP)

	method teEncontro(personaje) {
		game.clear()
		pantallaNueva.iniciar()
		self.cambiarPosicion(personaje)
	}

	method cambiarPosicion(personaje) {
		personaje.position().x(posX)
		personaje.position().y(posY)
	}

	method recibirAtaque() {
	}

	method recibirAtaque(danio) {
	}

}

class Muro inherits Teleport {

	override method teEncontro(personaje) {
		self.cambiarPosicion(personaje)
	}

	override method cambiarPosicion(personaje) {
		super(personaje)
		self.darLaVuelta(personaje)
		personaje.actualizarImagen()
	}

	method darLaVuelta(personaje) {
		personaje.direccion().darLaVuelta(personaje)
		}
}

const tpTunelAbajo = new Teleport(xTP = 12, yTP = 1, pantallaNueva = pantalla1, posX = 4, posY = 9)

const bloqueoIzquierdaArriba = new Muro(xTP = -1, yTP = 5, posX = 0, posY = 5)

const bloqueoIzquierdaAbajo = new Muro(xTP = -1, yTP = 1, posX = 0, posY = 1)

const bloqueoDerechaArriba = new Muro(xTP = 20, yTP = 5, posX = 19, posY = 5)

const bloqueoDerechaAbajo = new Muro(xTP = 20, yTP = 1, posX = 19, posY = 1)


const bloqueoIzquierdaMedioPantalla3 = new Muro(xTP = -1, yTP = 4, posX = 0, posY = 4)

const bloqueoIzquierdaAbajoPantalla3 = new Muro(xTP = -1, yTP = 0, posX = 0, posY = 0)

const bloqueoDerechaArribaPantalla3 = new Muro(xTP = 20, yTP = 8, posX = 19, posY = 8)

const bloqueoDerechaMedioPantalla3 = new Muro(xTP = 20, yTP = 4, posX = 19, posY = 4)

const bloqueoDerechaArribaDragon = new Muro(xTP = -1, yTP = 7, posX = 0, posY = 7)

const bloqueoDerechaMedioDragon = new Muro(xTP = -1, yTP = 4, posX = 0, posY = 4)

const bloqueoEnElDragon = new Muro(xTP = 18, yTP = 1, posX = 17, posY = 1)
const bloqueoEntradaDragon = new Muro (xTP = -1, yTP = 1, posX = 0, posY = 1)

const bloqueoBordeCannon03 = new Muro(xTP = 10, yTP = 7, posX = 9, posY = 7)

const bloqueoBordeCannon02 = new Muro(xTP = 10, yTP = 4, posX = 9, posY = 4)

const tpPantalla2 = new Teleport(xTP = 20, yTP = 1, pantallaNueva = pantalla2, posX = 0, posY = 5)

const tpPantalla3 = new Teleport(xTP = 20, yTP = 1, pantallaNueva = pantalla3, posX = 0, posY = 8)

const tpPantalla4 = new Teleport(xTP = 20, yTP = 0, pantallaNueva = pantalla4, posX = 0, posY = 1)

const tpRegresoPantalla3 = new Teleport(xTP = -1, yTP = 1, pantallaNueva = pantalla3, posX = 19, posY = 1)

const tpRegresoPantalla2 = new Teleport(xTP = -1, yTP = 8, pantallaNueva = pantalla2, posX = 19, posY = 1)

const tpRegresoPantalla1 = new Teleport(xTP = -1, yTP = 5, pantallaNueva = pantalla1, posX = 19, posY = 1)

const tpWulgrym = new Teleport(xTP = -1, yTP = 1, pantallaNueva = wulgrymEncuentro, posX = 19, posY = 1)

const tpWulgrymRegresoPantalla2 = new Teleport(xTP = 20, yTP = 1, pantallaNueva = pantalla2, posX = 0, posY = 1)

