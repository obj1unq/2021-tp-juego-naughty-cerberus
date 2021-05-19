import wollok.game.*

object personajePrincipal {

	var property vida = 100
	var property energia = 100
	var property position = game.at(0, 1)

	method image() = "personaje.png"

	method moverse(nuevaPosicion) {
		position = nuevaPosicion
	}

	method esquivar(nuevaPosicion) {
		self.verificarEnergia()
		energia -= 10
		position = nuevaPosicion
	}

	method verificarEnergia() {
		if (energia < 20) {
			self.error("no tengo energia para esquivar")
		}
	}

	method recargarEnergia() {
		// recarga 2 de energia cada segundo
		if (energia < 100) {
			energia += 1
		}
	}

}

