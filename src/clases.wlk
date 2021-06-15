import personaje.*
import wollok.game.*

class Mode {

	var property speedFrame // la velocidad de animacion de los frames(en ms)
	var property totalImg // la cantidad total de imagenes(cantidad de frames)
	var property time // el comienzo del conteo de cantidad de img
	var property accion // el tipo de accion que realizará: (Run,Die,Attack,Dodge)

	method realizarAccion(personaje, direccion) {
		self.mover(personaje)
		imageNameConversor.getImgName(personaje, accion, direccion, self.time().toString()) // direccion(derecha o izquierda) hacia donde hará la animacion
		if (self.time() == totalImg) {
			game.removeTickEvent(accion)
			time = 0
			game.schedule(500, { => personaje.image(direccion.imagenPersonajeStand(personaje.nombre()))})
		}
	}

	method accion(personaje, direccion) { // el llamado principal (el q comienza a ejecutar el resto de metodos de animacion)
		game.onTick(speedFrame, accion, {=> self.realizarAccion(personaje, direccion)})
	}

	method mover(personaje) {
		time += 1
	}

} // La idea es que para facilitarnos la vida, las animaciones sean solo de a 3 imagenes.
// Bug detectado: si spameas mucho el movimiento, el personaje se queda quieto y no se mueve más

object runModeL inherits Mode(accion = "Run", speedFrame = 30, totalImg = 4, time = 0) {

	override method mover(personaje) {
		time += 1
		personaje.position().x(personaje.position().x() - 0.25)
	// personaje.actualizarPosicion(personaje.position().left(0.25)) // delegar responsabilidad a actualizarPosicion(que luego será cambiado)
	}

}

object runModeR inherits Mode(accion = "Run", speedFrame = 30, totalImg = 4, time = 0) {

	override method mover(personaje) {
		time += 1
		personaje.position().x(personaje.position().x() + 0.25)
	// personaje.actualizarPosicion(personaje.position().right(0.25))
	}

}

const attackMode = new Mode(accion = "Attack", speedFrame = 65, totalImg = 3, time = 0)

//const atacarEnemigoADistancia = new Mode(accion = "AttackDistance",speedFrame = 65, totalImg = 3, time=0)
//const atacarEnemigoAMelee = new Mode(accion = "AttackMelee",speedFrame = 65, totalImg = 3, time=0)
const dodgeMode = new Mode(accion = "Dodge", speedFrame = 65, totalImg = 3, time = 0)

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

