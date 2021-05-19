import wollok.game.*

object personajePrincipal {

	var property vida = 100
	var property energia = 100
	var property mirandoA = "Right"
	var property position = game.at(0, 1)

	method image() = "personaje.png"

	method moverse(nuevaPosicion) {
		position = nuevaPosicion
	}
	
	method orientacionEsquivar(){	// Hacia donde está mirando el personaje
		if (mirandoA == "Right"){
			return self.position().right(1)
		}
		else {
			return self.position().left(1)
		}
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
		// recarga 10 de energia (la idea es que sea cada segundo)
		energia = (energia + 10).min(100)

	}

}

