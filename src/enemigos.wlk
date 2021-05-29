import wollok.game.*
import clases.*
import personaje.*
import misc.*

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
		game.sound("espada-sfx.mp3").play()
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
		pocionDeVida.position(self.position())
		game.addVisual(pocionDeVida)
		game.removeVisual(self)
		
	}


	method recorrerPiso() {
		game.onTick(750, "spectrum recorre el piso hasta encontrar al MC", { => self.patrullarYCazarMC()})
	}

	method patrullarYCazarMC() {
		if (!self.mcEnMiNivel()) {
			self.caminarHastaElBorde()
		} else {
			self.spectrumDejaDePatrullar()
			self.perseguirMC()
		}
	}
	
	method spectrumDejaDePatrullar() {
		return game.removeTickEvent("spectrum recorre el piso hasta encontrar al MC")
	}

	method caminarHastaElBorde() {
		if (!self.estaEnElBorde())  {
			self.moverse()
		} else {
			self.darLaVuelta()
			self.moverse()
		}
	}

	method estaEnElBorde() {
		return self.position().x() == 0 || self.position().x() == 19
	}

	method darLaVuelta() {
		if (direccion == right) {
			self.direccion(left)
		} else {
			self.direccion(right)
		}
	}

	method perseguirMC() {
		self.verificarQueSigaEnMiNivel()
		self.ponerseEnRangoParaAtacar()
	}

	method verificarQueSigaEnMiNivel() {
		if (!self.mcEnMiNivel()) {
			self.recorrerPiso()
		}
	}

	method mcEnMiNivel() {
		return self.position().y() == personajePrincipal.position().y()
	}

	method ponerseEnRangoParaAtacar() {
		if (!self.estaCercaDelMC()) {
			self.spectrumSeAcercaAlMC()
		} else {
			self.atacar()
		}
	}
	
	method spectrumSeAcercaAlMC() {
		return game.onTick(500, "acercarse al MC", { => self.moverseHaciaMCSiEstaEnElArea()})
	}

	method estaCercaDelMC() {
		return ((self.position().x() - personajePrincipal.position().x()).abs()) < 2
	}

	method moverseHaciaMCSiEstaEnElArea() {
		if (!self.mcEnMiNivel()) {
			self.spectrumDejaDeAcercarseAlMC()
			self.recorrerPiso()
		} else {
			self.moverseHaciaMC() 
		}
	}
	
	method spectrumDejaDeAcercarseAlMC() {
		return game.removeTickEvent("acercarse al MC")
	}
	
	
	method moverseHaciaMC() {
		if (self.mcALaIzquierda() && !self.estaCercaDelMC()) {
			direccion = left
			self.moverse()
		}
		if (self.mcALaDerecha() && !self.estaCercaDelMC()) {
			direccion = right
			self.moverse()
		} 

	}

	method mcALaIzquierda() {
		return self.position().x() > personajePrincipal.position().x()
	}

	method mcALaDerecha() {
		return self.position().x() < personajePrincipal.position().x()
	}
	
	
	method teEncontro(personaje) {
		
	}

}

const spectrum02 = new Spectrum(vida = 500, ataque = 20, defensa = 10, direccion = right, position = game.at(2, 5), nombre = "spectrum", image = right.imagenPersonajeStand("spectrum"))

//const spectrum01 = new Spectrum(vida =  500, ataque = 20, defensa = 10, direccion = left, position = game.at(9,1), 
// nombre = "spectrum",image = left.imagenPersonajeStand("spectrum"))
