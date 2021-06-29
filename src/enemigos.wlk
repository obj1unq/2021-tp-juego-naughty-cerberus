import wollok.game.*
import clases.*
import personaje.*
import misc.*

class Enemies {

	var property vida = 500
	var property ataque = 35
	var property defensa = 10
	var property direccion = right
	var property position = new MiPosicion(x = 0, y = 0)
	var property nombre
	var property pocionDeVidaAsignada
	var image

	method image() = image

	method image(imagen) {
		image = imagen
	}

	method actualizarPosicion(nuevaPosicion) {
		position = nuevaPosicion
	}

	method actualizarImagen() {
		self.image(direccion.imagenPersonajeStand(nombre.toString()))
	}

	method moverse() {
		direccion.move(self, 1)
	}

	method atacar() {
		self.dejaDeAcercarseAlMC()
		self.mirarAlMC()
	}

	method dejaDeAcercarseAlMC() {
		game.removeTickEvent(self.toString() + "se acerca al MC")
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

	method recibirAtaque(danio) {
	} // method vacio para evitar errores,y que a su vez los enemigos no se maten entre si(ya que si todos entendieran el mismo msj se matarian xD)

	method morir() {
//		self.dejarDeAtacar()
		game.schedule(1, { => self.dejarDeAtacar()})
		self.dieMode().accion(self, self.direccion())
	}

	method dieMode()

	method patrullarYCazarMC() {
		if (self.mcEnMiNivel()) {
			self.atacarSiSeAcerca()
		}
	}

	method atacarSiSeAcerca() {
	}

	method vigilarPiso() {
		self.ponersePasivo()
		game.onTick(750, self.toString() + "recorre el piso hasta encontrar al MC", { => self.patrullarYCazarMC()})
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

	method dejaDePatrullar() {
		game.removeTickEvent(self.toString() + "recorre el piso hasta encontrar al MC")
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
		return self.position().x() <= 1 or self.position().x() >= 18
	}

	method darLaVuelta() {
		if (direccion == right) {
			self.direccion(left)
			self.actualizarImagen()
//			self.moverse()
		} else {
			self.direccion(right)
			self.actualizarImagen()
//			self.moverse()
		}
	}

	method perseguirMC() {
		self.verificarQueSigaEnMiNivel()
		self.ponerseEnRangoParaAtacar()
	}

	method verificarQueSigaEnMiNivel() {
		if (!self.mcEnMiNivel()) {
			self.vigilarPiso()
			self.ponersePasivo()
		}
	}

	method mcEnMiNivel() {
		return self.position().y() == personajePrincipal.position().y()
	}

	method ponerseEnRangoParaAtacar() {
		if (self.estaCercaDelMC()) {
			self.atacar()
		} else {
			self.seAcercaAlMC()
		}
	}

	method dejarDeAtacar() {
		game.removeTickEvent(self.toString() + "comienza a atacar")
		if (vida > 0) {
			self.vigilarPiso()
		}
	}

	method ponerseActivo() {
		self.actualizarImagen()
	}

	method ponersePasivo() {
		self.actualizarImagen()
	}

	method seAcercaAlMC() {
		game.onTick(450, self.toString() + "se acerca al MC", { => self.moverseHaciaMCSiEstaEnElPiso()})
	}

	method estaCercaDelMC() {
		return ((self.position().x() - personajePrincipal.position().x()).abs()) < 7
	}

	method moverseHaciaMCSiEstaEnElPiso() {
		if (!self.mcEnMiNivel()) {
			self.dejaDeAcercarseAlMC()
			self.vigilarPiso()
		} else {
			self.moverseHaciaMCYAtacar()
		}
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

	method estaVivo() {
		return game.allVisuals().contains(self) and self.vida() > 0
	}

}

class Spectrum inherits Enemies {

	override method patrullarYCazarMC() {
		if (!self.mcEnMiNivel()) {
			self.caminarHastaElBorde()
		} else {
			self.ponerseActivo()
			self.dejaDePatrullar()
			self.seAcercaAlMC()
		}
	}

	override method atacar() {
		super()
		fuego.lanzar(self)
		game.onTick(1450, self.toString() + "comienza a atacar", { => fuego.lanzar(self)})
	}

	override method ponerseActivo() {
		nombre = "spectrumAct"
		super()
	}

	override method ponersePasivo() {
		nombre = "spectrum"
		super()
	}

	override method morir() {
//		self.ponerseActivo()
		super()
		game.schedule(799, { => game.removeVisual(self)})
		game.schedule(800, { => pocionDeVidaAsignada.spawn(self)})
	}

	override method dieMode() {
		return new Mode(accion = "Die", speedFrame = 100, totalImg = 8, time = 0)
	}

}

class Ogre inherits Enemies {

	override method atacarSiSeAcerca() {
		if (self.estaCercaDelMC()) {
			self.ponerseActivo()
			self.dejaDePatrullar()
			self.atacar()
		}
	}

	override method ponerseActivo() {
		self.nombre("ogreAct")
		super()
	}

	override method ponersePasivo() {
		self.nombre("ogre")
		super()
	}

	method mcEstaMuyLejos() {
		return ((self.position().x() - personajePrincipal.position().x()).abs()) >= 10
	}

	override method atacar() {
		self.ponerseActivo()
		flecha.lanzar(self)
		game.onTick(1500, self.toString() + "comienza a atacar", { => flecha.lanzar(self)})
	}

	override method dieMode() {
		return new Mode(accion = "Die", speedFrame = 250, totalImg = 7, time = 0)
	}

	override method morir() {
		super()
		game.schedule(1750, { => game.removeVisual(self)})
		game.schedule(1750, { => pocionDeVidaAsignada.spawn(self)})
	}

	method reloadMode() {
		return new Mode(accion = "reload", speedFrame = 130, totalImg = 8, time = 0)
	}

	method recargarBallesta() {
		self.reloadMode().accion(self, self.direccion())
	}

}

class Wolf inherits Enemies {

	override method ponerseActivo() {
		nombre = "wolfAct"
		super()
	}

	override method ponersePasivo() {
		nombre = "wolf"
		super()
	}

	override method moverse() {
		direccion.moveWolf(self)
	}

	override method atacarSiSeAcerca() {
		self.mirarAlMC()
		self.ponerseActivo()
		if (self.estaCercaDelMC()) {
			self.dejaDePatrullar()
			self.modoRabioso()
			game.sound("wolfActive-sfx.mp3").play()
		}
	}

	method modoRabioso() {
		game.onTick(140, self.toString() + "corre hasta los bordes", { => self.caminarHastaElBorde()})
	}

	override method caminarHastaElBorde() {
		self.verificarQueSigaEnMiNivel()
		if (self.estaVivo()) {
			super()
		} else {
			self.morir()
		}
	}

	method salirModoRabioso() {
		game.removeTickEvent(self.toString() + "corre hasta los bordes")
	}

	method dejarDeIrHaciaLosBordes() {
		game.removeTickEvent(self.toString() + "corre hasta los bordes")
		self.vigilarPiso()
	}

	override method dieMode() {
		return new Mode(accion = "Die", speedFrame = 250, totalImg = 8, time = 0)
	}

	override method verificarQueSigaEnMiNivel() {
		if (!self.mcEnMiNivel()) {
			game.schedule(140, { =>
				self.salirModoRabioso()
				self.vigilarPiso()
			})
//			self.salirModoRabioso()
//			self.vigilarPiso()
//			game.schedule(140, {=> self.vigilarPiso()})
		}
	}

	override method morir() {
		if (!self.estaAturdido()) {
			self.salirModoRabioso()
		} else {
			self.ponerseActivo()
		}
		self.dieMode().accion(self, self.direccion())
		game.schedule(2000, { => game.removeVisual(self)})
		game.schedule(2000, { => pocionDeVidaAsignada.spawn(self)})
	}

	override method teEncontro(objeto) {
		if (objeto == personajePrincipal and personajePrincipal.blockStance()) {
			self.aturdirseBrevemente()
		} else {
			objeto.recibirAtaque(ataque)
		}
	}

	method aturdirseBrevemente() {
		self.salirModoRabioso()
		game.schedule(280, { => self.modoAturdido()})
//		self.ponerseActivo()
//		self.modoAturdido()
		game.schedule(1850, { =>
			if (self.estaVivo()) {
				self.ponerseActivo()
				self.modoRabioso()
			}
		})
	}

	method modoAturdido() {
//		self.salirModoRabioso()
		nombre = "wolfStunned"
		self.actualizarImagen()
	}

	/* 	method stunnedMode() {
	 * 		return new Mode(accion = "stunned", speedFrame = 100, totalImg = 4, time = 0)
	 * 	}
	 */
	method estaAturdido() {
		return nombre == "wolfStunned"
	}

	override method darLaVuelta() {
		super()
		self.irAlBordeMasCercano()
		self.moverse()
	}

	method irAlBordeMasCercano() {
		if (self.position().x() < 10) {
			self.position().x(1)
		} else {
			self.position().x(18)
		}
	}

}

class Proyectiles {

	var property position
	var property image
	var property direccion
	var property danioBase = 10

	method lanzar(enemigo) {
		self.removeVisualSiYaExiste()
//		self.verificarQueSigaVivo(enemigo)
		self.verificarQueElMCEsteEnElPisoYEstaCerca(enemigo)
		enemigo.mirarAlMC()
		self.position(new MiPosicion(x = enemigo.position().x(), y = enemigo.position().y()))
		self.direccion(enemigo.direccion())
		self.image()
		game.addVisual(self)
	}

	method verificarQueSigaVivo(enemigo) {
		if (!enemigo.estaVivo()) {
			enemigo.dejarDeAtacar()
		}
	}

	method removeVisualDelProyectil() {
		game.schedule(1000, { => self.removeVisualSiYaExiste()})
	}

	method verificarQueElMCEsteEnElPisoYEstaCerca(enemigo) {
		if (!enemigo.mcEnMiNivel() or !enemigo.estaCercaDelMC()) {
			enemigo.dejarDeAtacar()
			self.removeVisualSiYaExiste()
		}
	}

	method removeVisualSiYaExiste() {
		if (game.allVisuals().contains(self)) {
			game.removeVisual(self)
		}
	}

	method image() {
		return self.toString() + "_" + direccion.toString() + ".png"
	}

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

	method recibirAtaque() {
	}

	method recibirAtaque(danio) {
	}

}

object fuego inherits Proyectiles {

	override method lanzar(enemigo) {
		super(enemigo)
		game.onTick(200, "desplazamiento bola de fuego", {=> self.desplazar()})
		game.schedule(1399, { => game.removeTickEvent("desplazamiento bola de fuego")})
		game.schedule(1399, { => self.removeVisualSiYaExiste()})
	}

}

object flecha inherits Proyectiles {

	override method lanzar(enemigo) {
		super(enemigo)
		enemigo.recargarBallesta()
		game.onTick(100, "desplazamiento flecha", {=> self.desplazar()})
		game.schedule(1400, { => game.removeTickEvent("desplazamiento flecha")})
		game.schedule(1400, { => self.removeVisualSiYaExiste()})
	}

}

//const ogre01 = new Ogre(vida = 800, ataque = 30, defensa = 20, direccion = right, position = new MiPosicion(x = 2, y = 5), nombre = "Ogre", image = right.imagenPersonajeStand("ogre"), pocionDeVidaAsignada = pocionDeVida01)
const spectrum01 = new Spectrum(vida = 500, ataque = 20, defensa = 10, direccion = left, position = new MiPosicion(x = 2, y = 5), nombre = "Spectrum", image = left.imagenPersonajeStand("spectrum"), pocionDeVidaAsignada = pocionDeVida01)

const wolf01 = new Wolf(vida = 500, ataque = 35, defensa = 0, direccion = left, position = new MiPosicion(x = 12, y = 1), nombre = "wolf", image = left.imagenPersonajeStand("wolf"), pocionDeVidaAsignada = pocionDeVida02)

//const spectrum02 = new Spectrum(vida = 500, ataque = 20, defensa = 10, direccion = right, position = new MiPosicion(x = 2, y = 5), nombre = "Spectrum", image = right.imagenPersonajeStand("spectrum"))
//const spectrum01 = new Spectrum(vida =  500, ataque = 20, defensa = 10, direccion = left, position = g//(9,1), 
// nombre = "spectrum",image = left.imagenPersonajeStand("spectrum"))
