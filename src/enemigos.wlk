import wollok.game.*
import clases.*
import personaje.*

class Spectrum {

	var property vida = 500
	var property ataque = 20
	var property defensa = 10
	var property direccion = left
	var property position = game.at(15, 1)
	var property nombre = "spectrum"
	var image = direccion.imagenPersonajeStand(nombre)

	method image() = image

	method image(imagen) {
		image = imagen
	}

	method actualizarPosicion(nuevaPosicion) {
		position = nuevaPosicion
	}

	method moverse() {
		direccion.move(self, 1)
	}

	method atacar() {
	// T0D0: código aqui pls
	}

	method recibirAtaque() {
		self.validarVida()
		vida = vida - self.calculoDeDanio()
	} // la formula actual es: ATK(del MC en este caso) *  (1 - DEF / (100 + DEF))  

	method calculoDeDanio() {
		return personajePrincipal.ataque() * (1 - self.defensa() / (100 + self.defensa()))
	}

	method validarVida() {
		if (vida - self.calculoDeDanio() <= 0) {
			self.morir()
		}
	}

	method morir() {
		game.removeVisual(self)
	}

	method perseguirMC() {
		if (self.mcEnMiNivel()) {
			self.ponerseEnRangoParaAtacar()
		} else {
			self.volverAPosicionOriginal()
		}
	}

	method volverAPosicionOriginal() {
	// TODO
	}

	method mcEnMiNivel() {
		return self.position().y() == personajePrincipal.position().y()
	}

	method ponerseEnRangoParaAtacar() {
		if (!self.estaCercaDelMC()) {
			game.onTick(500, "acercarse al MC", { => self.moverseHaciaMC()})
		} else {
			self.atacar()
		}
	}

	method estaCercaDelMC() {
		return ((self.position().x() - personajePrincipal.position().x()).abs()) < 2
	}

	method moverseHaciaMC() {
		if (self.mcALaIzquierda() && !self.estaCercaDelMC()) {
			self.direccion(left)
			self.moverse()
		}
		if (self.mcALaDerecha() && !self.estaCercaDelMC()) {
			self.direccion(right)
			self.moverse()
		}
	}

	method mcALaIzquierda() {
		return self.position().x() > personajePrincipal.position().x()
	}

	method mcALaDerecha() {
		return self.position().x() < personajePrincipal.position().x()
	}

}

const spectrum01 = new Spectrum()

//const spectrum01 = new Spectrum(vida =  500, ataque = 20, defensa = 10, direccion = left, position = game.at(9,1), 
// nombre = "spectrum",image = left.imagenPersonajeStand("spectrum"))
