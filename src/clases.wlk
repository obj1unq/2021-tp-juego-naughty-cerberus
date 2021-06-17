import personaje.*
import wollok.game.*

class Mode {

	var property speedFrame // la velocidad de animacion de los frames(en ms)
	var property totalImg // la cantidad total de imagenes(cantidad de frames)
	var property time // el comienzo del conteo de cantidad de img
	var property accion // el tipo de accion que realizará: (Run,Die,Attack,Dodge)

	method realizarAccion(objeto, direccion) {
		self.timeLapse(objeto)
		imageNameConversor.getImgName(objeto, accion, direccion, self.time().toString()) // direccion(derecha o izquierda) hacia donde hará la animacion
		if (self.time() == totalImg) {
			game.removeTickEvent(accion)
			time = 0
			game.schedule(500, { => objeto.image(direccion.imagenPersonajeStand(objeto.nombre()))})
		}
	}

	method accion(objeto, direccion) { // el llamado principal (el q comienza a ejecutar el resto de metodos de animacion)
		game.onTick(speedFrame, accion, {=> self.realizarAccion(objeto, direccion)})
	}

	method timeLapse(objeto) {
		time += 1
	}

}


object runModeL inherits Mode(accion = "Run", speedFrame = 30, totalImg = 4, time = 0) {

	override method timeLapse(objeto) {
		time += 1
		objeto.position().x(objeto.position().x() - 0.25)
	// objeto.actualizarPosicion() // delegar responsabilidad a actualizarPosicion(que luego será cambiado por move() seguramente)
	}

}

object runModeR inherits Mode(accion = "Run", speedFrame = 30, totalImg = 4, time = 0) {

	override method timeLapse(objeto) {
		time += 1
		objeto.position().x(objeto.position().x() + 0.25)
	// objeto.actualizarPosicion() //lo mismo que en runModeL
	}

}
class AttackMC inherits Mode{ //quiza luego este attackMC se convierta en un attack generico para los melee??
	override method realizarAccion(objeto, direccion) {
		//objeto.image(direccion.imagenPersonajeAttack(objeto.portador().nombre())) usando algo así como esto
		personajePrincipal.image(direccion.imagenPersonajeAttack(personajePrincipal.nombre()))
		self.timeLapse(objeto)
		imageNameConversor.getImgName(objeto, accion, direccion, self.time().toString()) // direccion(derecha o izquierda) hacia donde hará la animacion
		if (self.time() == totalImg) {
			game.removeTickEvent(accion)
			time = 0
			game.schedule(500, { => personajePrincipal.image(direccion.imagenPersonajeStand(personajePrincipal.nombre()))
									objeto.image("sword_void.png")})
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

