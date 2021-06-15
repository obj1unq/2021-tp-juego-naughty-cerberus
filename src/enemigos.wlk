import wollok.game.*
import clases.*
import personaje.*
import misc.*

class Spectrum {

	var property vida = 500
	var property ataque = 20
	var property defensa = 10
	var property direccion = left
	var property position = new MiPosicion(x = 15, y = 1)
	var property nombre = "spectrum"
	var image = direccion.imagenPersonajeStand(nombre)

	method image() = image

	method image(imagen) {
		image = imagen
	}

	method actualizarPosicion(nuevaPosicion) {
		position = nuevaPosicion
	}

	method actualizarImagen() {
		self.image(direccion.imagenPersonajeStand(self.nombre()))
	}

	method moverse() {
		direccion.move(self, 1)
	}

	method atacar() {
		proyectilDeFuego.lanzar(self)
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
		// self.spectrumDejaDeAcercarseAlMC()
		self.dieMode().accion(self, self.direccion())
		game.schedule(800, { => game.removeVisual(self)})
	}

	method dieMode() {
		return new Mode(accion = "Die", speedFrame = 100, totalImg = 8, time = 0)
	}

	method recorrerPiso() {
		self.ponersePasivo()
		game.onTick(750, "spectrum recorre el piso hasta encontrar al MC", { => self.patrullarYCazarMC()})
	}

	method patrullarYCazarMC() {
		if (!self.mcEnMiNivel()) {
			self.caminarHastaElBorde()
		} else {
			self.ponerseActivo()
			self.spectrumDejaDePatrullar()
			self.spectrumSeAcercaAlMC()
		}
	}

	method atacarMCSiEstaEnRango() {
		if (self.estaCercaDelMC()) {
			self.mirarAlMC()
			self.atacar()
		}
	}

	method mirarAlMC() {
		if (self.mcALaDerecha()) {
			direccion = right
			self.actualizarImagen()
		} else {
			direccion = left
			self.actualizarImagen()
		}
	}

	method spectrumDejaDePatrullar() {
		return game.removeTickEvent("spectrum recorre el piso hasta encontrar al MC")
	}

	method caminarHastaElBorde() {
		if (!self.estaEnElBorde()) {
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
			self.actualizarImagen()
		} else {
			self.direccion(right)
			self.actualizarImagen()
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
		if (self.estaCercaDelMC()) {
			self.atacar()
		} else {
			self.spectrumSeAcercaAlMC()
		}
	}

	method dejarDeAtacar() {
		game.removeTickEvent("lanzar proyectil de fuego")
	}

	method ponerseActivo() {
		nombre = "spectrumAct"
		self.actualizarImagen()
	}

	method ponersePasivo() {
		nombre = "spectrum"
		self.actualizarImagen()
	}

	method spectrumSeAcercaAlMC() {
		game.onTick(450, "acercarse al MC", { => self.moverseHaciaMCSiEstaEnElPiso()})
	}

	method estaCercaDelMC() {
		return ((self.position().x() - personajePrincipal.position().x()).abs()) < 6
	}

	method moverseHaciaMCSiEstaEnElPiso() {
		if (!self.mcEnMiNivel()) {
			self.spectrumDejaDeAcercarseAlMC()
			self.recorrerPiso()
		} else {
			self.moverseHaciaMCYAtacar()
		}
	}

	method spectrumDejaDeAcercarseAlMC() {
		game.removeTickEvent("acercarse al MC")
	}

	method moverseHaciaMCYAtacar() {
		if (self.mcALaIzquierda() && !self.estaCercaDelMC()) {
			direccion = left
			self.moverse()
			self.actualizarImagen()
		}
		if (self.mcALaDerecha() && !self.estaCercaDelMC()) {
			direccion = right
			self.moverse()
			self.actualizarImagen()
		}
		if (self.estaCercaDelMC()) {
			self.ponerseActivo()
			self.atacar()
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

object proyectilDeFuego {

	var property position
	var property direccion = null
	var property image
	const danioBase = 15

	method lanzar(enemigo) {
		self.verificarQueElMCEsteEnElPiso(enemigo)
		self.removeVisualSiYaExiste()
		self.position(enemigo.position())
		self.direccion(enemigo.direccion())
		self.image("fuego_" + direccion + ".png")
		game.addVisual(self)
		game.onTick(200, "desplazarse", {=> self.desplazar()})
	}

	method verificarQueElMCEsteEnElPiso(enemigo) {
		if (!enemigo.mcEnMiNivel()) {
			game.removeTickEvent("lanzar proyectil de fuego")
		}
	}

	method removeVisualSiYaExiste() {
		if (game.allVisuals().contains(self)) {
			game.removeVisual(self)
		}
	}

	method image() = image

	method desplazar() {
		direccion.move(self, 1)
	}

	method teEncontro(objeto) {
		objeto.recibirAtaque(danioBase)
		if (objeto == personajePrincipal) {
			game.removeVisual(self)
		}
	}

	method actualizarPosicion(nuevaPosicion) {
		position = nuevaPosicion
	}

}

const spectrum02 = new Spectrum(vida = 500, ataque = 20, defensa = 10, direccion = right, position = new MiPosicion(x = 2, y = 5), nombre = "spectrum", image = right.imagenPersonajeStand("spectrum"))

//const spectrum01 = new Spectrum(vida =  500, ataque = 20, defensa = 10, direccion = left, position = g//(9,1), 
// nombre = "spectrum",image = left.imagenPersonajeStand("spectrum"))
