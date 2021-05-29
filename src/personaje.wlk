import wollok.game.*
import clases.*
import enemigos.*
import misc.*

object personajePrincipal {

	var property vida = 100
	var property energia = 100
	var property ataque = 100
	var property defensa = 1
	var property direccion = right
	var property position = game.at(0, 1)
	var image = direccion.imagenPersonajeStand(self.nombre())

	method image() = image

	method image(imagen) {
		image = imagen
	}

	method nombre() = "personaje"

	method actualizarPosicion(nuevaPosicion) {
		position = nuevaPosicion
	}

	method moverse() {
		direccion.moveMC()
	}

	method esquivar() {
		self.verificarEnergia()
		energia -= 30
		direccion.move(self, 2)
	}

	method verificarEnergia() {
		if (energia < 30) {
			self.error("No tengo energia para esquivar")
		}
	}

	method recargarEnergia() {
		// recarga 10 de energia (la idea es que sea cada segundo)
		energia = (energia + 10).min(100)
	}

	method atacar() {
		direccion.atacarMC()
		self.colisionarGolpe()
	}

	method colisionarGolpe() { // Hay que corregir el area de colision porque desde el lado derecho solo colisionan cuando estan en la misma posicion
		game.colliders(self).forEach{ objeto => objeto.recibirAtaque()}
	}


	method subirPorEscalera() {
		if (self.hayEscalera()) {
			self.irAlPisoDeArriba()
		} else {
			game.say(self, "no hay escalera para subir")
		}
	}
	
	method bajarPorEscotilla() {
		if (self.hayEscotilla()) {
			self.irAlPisoDeAbajo()
		} else {
			game.say(self, "no hay escotilla para bajar")
		}
	}
	
	
	method hayEscalera() {
		return game.colliders(self).contains(escalera)
	}

	method hayEscotilla() {
		return game.colliders(self).contains(escotilla)
	}

	method irAlPisoDeArriba() {
		self.actualizarPosicion(game.at(self.position().x(), self.position().y() + 4))
	}

	method irAlPisoDeAbajo() {
		self.actualizarPosicion(game.at(self.position().x(), self.position().y() - 4))
	}
	

}

object left {

	var doubleTap = false

	method moveMC() { // Mov izquierda del MainCharacter (personaje principal)	
	 //if(!doubleTap){ // Un pequeño retraso para no spamear botones de movilidad(y hacer más valioso el esquivar)			
		game.schedule(1, { => doubleTap = true})
		runModeL.accion(personajePrincipal, personajePrincipal.direccion())
		game.schedule(100, { => doubleTap = false})
		game.schedule(500, { => personajePrincipal.image(self.imagenPersonajeStand(personajePrincipal.nombre()))})
	// }// Esta parte se podria reemplazar por una animacion continua de moverse pero no veo forma de hacerlo viable.
	}

	method move(objeto, num) { // general para cualquier objecto, pensado para usarse en los enemigos
		objeto.actualizarPosicion(objeto.position().left(num)) // todos los objetos que se muevan deben entender el metodo "actualizarPosicion"
	}

	method imagenPersonajeStand(objeto) {
		return objeto + "_Stand_left.png"
	} // El atacar del lado izquierdo tiene problemas de posionamiento debido al funcionamiento del metodo addvisual de wollok

	method atacarMC() { // por lo cual tendrá un poco más de codigo para reparar el error
		if (!doubleTap) {
			game.schedule(1, { => doubleTap = true})
			personajePrincipal.image(vacio.imagenVacia())
			personajePrincipal.actualizarPosicion(personajePrincipal.position().left(2))
			attackMode.accion(personajePrincipal, personajePrincipal.direccion())
			personajePrincipal.image(vacio.imagenVacia())
			game.schedule(500, { =>
				personajePrincipal.actualizarPosicion(personajePrincipal.position().right(2))
				personajePrincipal.image(self.imagenPersonajeStand(personajePrincipal.nombre()))
				doubleTap = false
			})

		}
	}

}

object right {

	var doubleTap = false

	method moveMC() { // Mov derecha del MainCharacter (personaje principal)	
	// if(!doubleTap){ // Un pequeño retraso para no spamear botones de movilidad(y hacer más valioso el esquivar)	(desactivado por ahora mientras se resuelven bugs)		
		game.schedule(1, { => doubleTap = true})
		runModeR.accion(personajePrincipal, personajePrincipal.direccion())
		game.schedule(100, { => doubleTap = false})
		game.schedule(500, { => personajePrincipal.image(self.imagenPersonajeStand(personajePrincipal.nombre()))})
	// }// Esta parte se podria reemplazar por una animacion continua de moverse pero no veo forma de hacerlo viable.
	}

	method move(objeto, num) { // general para cualquier objecto, pensado para usarse en los enemigos
		objeto.actualizarPosicion(objeto.position().right(num)) // todos los objetos que se muevan deben entender el metodo "actualizarPosicion"
	}

	method imagenPersonajeStand(objeto) {
		return objeto + "_Stand_right.png"
	}

	method atacarMC() {
		if (!doubleTap) {
			game.schedule(1, { => doubleTap = true})
			attackMode.accion(personajePrincipal, personajePrincipal.direccion())
			game.schedule(500, { => personajePrincipal.image(self.imagenPersonajeStand(personajePrincipal.nombre()))
									doubleTap = false})
		}
	}
	}


object imageNameConversor {

	method getImgName(objeto, accion, direccion, num) {
		objeto.image(objeto.nombre() + "_" + accion + "_" + direccion + "_" + num + ".png")
	}

}

object vacio {

	method imagenVacia() {
		return "void.png"
	}

}

