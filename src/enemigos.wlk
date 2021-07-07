import wollok.game.*
import clases.*
import personaje.*
import misc.*
import nivelesycfg.*

class Enemies {

	var property pantalla
	var property vida = 500
	var property ataque = 35
	var property defensa = 10
	var property direccion = right
	var property position = new MiPosicion(x = 0, y = 0)
	var property nombre
	var property pocionDeVidaAsignada
	const property vidaInicial = 500 // la vida maxima con la empieza un enemigo(sin modificarse)
	var property barraDeVida = new BarraDeVidaEnemigo(enemigo = self)
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

	method quitarDeLaPantalla() {
		game.removeVisual(self)
		pantalla.enemigos().remove(self)
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
		game.schedule(100, { => self.ponersePasivo()})
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

	method posicionBarra() {
		return 1
	}

	method esCannon() {
		return true
	}

	method esEscalera() {
		return false
	}

	method esEscotilla() {
		return false
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
		game.schedule(799, { => self.quitarDeLaPantalla()})
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
		game.schedule(1750, { => self.quitarDeLaPantalla()})
		game.schedule(1750, { => pocionDeVidaAsignada.spawn(self)})
	}

	method reloadMode() {
		return new Mode(accion = "reload", speedFrame = 130, totalImg = 8, time = 0)
	}

	method recargarBallesta() {
		game.sound("CrossbowReload.mp3").play()
		self.reloadMode().accion(self, self.direccion())
	}

	override method posicionBarra() {
		return 2
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

	/*override method atacarSiSeAcerca() {
	 * 	self.mirarAlMC()
	 * 	self.ponerseActivo()
	 * 	if (self.estaCercaDelMC()) {
	 * 		self.dejaDePatrullar()
	 * 		self.modoRabioso()
	 * 		game.sound("wolfActive-sfx.mp3").play()
	 * 	}
	 * }
	 */
	override method atacarSiSeAcerca() {
		self.mirarAlMC()
		self.ponerseActivo()
		self.ponerseRabiosoSiSeAcerca()
	}

	method ponerseRabiosoSiSeAcerca() {
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
			game.schedule(120, { => self.salirModoRabioso()})
			game.schedule(240, { => self.vigilarPiso()})
//			self.salirModoRabioso()
//			self.vigilarPiso()
		}
	}

	override method morir() {
		if (!self.estaAturdido()) {
			self.salirModoRabioso()
		} else {
			self.ponerseActivo()
		}
		self.dieMode().accion(self, self.direccion())
		game.sound("wolfDeath.mp3").play()
		game.schedule(2000, { => self.quitarDeLaPantalla()})
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
		game.sound("shieldBlock.mp3").play()
		game.schedule(40, { => self.salirModoRabioso()})
//	self.salirModoRabioso()
//		game.schedule(160, { => self.ponersePasivo()})
		game.schedule(500, { => self.modoAturdido()})
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

	override method posicionBarra() {
		return 0
	}

}

class Dragon inherits Enemies {

	var property balasRecibidas = 0

//	override method actualizarImagen() {
//		self.image()
//	}
	override method moverse() {
		direccion.moveDragon(self)
		game.sound("dragonFlap.mp3").play()
	}

	override method patrullarYCazarMC() {
		self.comenzarAAtacarCuandoSeAcerque()
	}

	method comenzarAAtacarCuandoSeAcerque() {
		if (self.estaCercaDelMC()) {
			self.dejaDePatrullar()
			self.ponerseActivo()
			self.despertarseYAtacar()
		}
	}

	override method ponerseActivo() {
		game.sound("dragonRoar.mp3").play()
		nombre = "dragonAct"
		super()
	}

	override method ponersePasivo() {
		nombre = "dragon"
		super()
	}

	method despertarseYAtacar() {
		game.schedule(1000, { => self.atacar()})
	}

	override method atacar() {
		if (self.estaVivo()) {
			game.schedule(500, { => fuegoDeDragon.lanzar(self) // self.moverseDosPisos()
//			self.moverse()
			})
			game.onTick(3000, self.toString() + "ataca y cambia de piso", { => self.atacarYCambiarDePiso()})
		}
	}

	method atacarYCambiarDePiso() {
		self.volarHastaElTechoOElSuelo()
		game.schedule(2000, { => fuegoDeDragon.lanzar(self)})
	}

	override method dejarDeAtacar() {
		game.removeTickEvent(self.toString() + "ataca y cambia de piso")
	}

	method volarHastaElTechoOElSuelo() {
		if (!self.estaEnElSueloOEnElTecho()) {
			self.moverseTresPisos()
		} else {
			self.darLaVuelta()
			self.moverseTresPisos()
		}
	}

	method moverseDosPisos() {
		self.moverse()
		game.schedule(1000, { => self.moverse()})
	}

	method moverseTresPisos() {
		self.moverse()
		game.schedule(500, { => self.moverse()})
		game.schedule(1000, {=> self.moverse()})
	}

	override method darLaVuelta() {
		if (direccion == up) {
			direccion = down
		} else {
			direccion = up
		}
	}

	method estaEnElSueloOEnElTecho() {
		return self.position().y() <= 1 or self.position().y() >= 7
	}

	method caerSiNoEstaEnElSuelo() {
		if (not self.position().y() == 1) {
			self.caerse()
		}
	}

	method caerHastaLlegarAlSuelo() {
		self.dejarDeAtacar()
		self.modoCaida()
		game.onTick(200, self.toString() + "cae hasta llegar al suelo", { => self.caerUnPisoHastaTocarElSuelo()})
	}

	method caerUnPisoHastaTocarElSuelo() {
		if (self.position().y() > 1) {
			self.caerse()
		} else {
			game.removeTickEvent(self.toString() + "cae hasta llegar al suelo")
			self.aturdirseBrevemente()
		}
	}

	method caerse() {
		self.position().y(self.position().y() - 1)
	}

	method modoCaida() {
		nombre = "dragonFalling"
		self.actualizarImagen()
	}

	method aturdirseBrevemente() {
		self.modoAturdido()
		self.defensa(100)
		game.schedule(6000, { => self.recomponerse()})
	}

	method modoAturdido() {
		nombre = "dragonStunned"
		self.actualizarImagen()
	}

	method recomponerse() {
		self.ponersePasivo()
		self.defensa(300)
		self.direccion(down)
		game.schedule(3000, { => self.dejarDeRecomponerse()})
		game.schedule(3000, { => self.atacar()})
	}

	method levantarse() {
		nombre = "dragon"
		self.actualizarImagen()
	}

	method dejarDeRecomponerse() {
		nombre = "dragonAct"
		self.actualizarImagen()
	}

	override method estaCercaDelMC() {
		return ((self.position().x() - personajePrincipal.position().x()).abs()) < 16
	}

	method recibirBala() {
		balasRecibidas += 1
	}

	override method morir() {
		game.sound("dragonDeath.mp3").play()
		self.ponersePasivo()
		self.direccion(down)
		self.dieMode().accion(self, self.direccion())
		game.schedule(1000, { => game.removeVisual(self)})
		game.schedule(4000, { => eventFinal.iniciar()})
	}

	override method dieMode() {
		return new Mode(accion = "Die", speedFrame = 250, totalImg = 4, time = 0)
	}

}

class Proyectiles {

	var property position
	var property image
	var property direccion
	var property danioBase = 50
	var property enemigoUtilizandolo

	method lanzar(enemigo) {
		self.enemigoUtilizandolo(enemigo)
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
		objeto.recibirAtaque((self.danioBase() * self.enemigoUtilizandolo().ataque()) / 100)
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
		game.sound("fireballSound.mp3").play()
		game.onTick(200, "desplazamiento bola de fuego", {=> self.desplazar()})
		game.schedule(1399, { => game.removeTickEvent("desplazamiento bola de fuego")})
		game.schedule(1399, { => self.removeVisualSiYaExiste()})
	}

}

object flecha inherits Proyectiles {

	override method lanzar(enemigo) {
		super(enemigo)
		enemigo.recargarBallesta()
		game.sound("arrowSound.mp3").play()
		game.onTick(100, "desplazamiento flecha", {=> self.desplazar()})
		game.schedule(1400, { => game.removeTickEvent("desplazamiento flecha")})
		game.schedule(1400, { => self.removeVisualSiYaExiste()})
	}

}

object fuegoDeDragon inherits Proyectiles {

	override method lanzar(enemigo) {
		self.removeVisualSiYaExiste()
//		self.verificarQueSigaVivo(enemigo)
//		self.verificarQueElMCEsteEnElPisoYEstaCerca(enemigo)
//		enemigo.mirarAlMC()
		self.position(new MiPosicion(x = enemigo.position().x(), y = enemigo.position().y()))
		self.direccion(left)
		self.image()
		game.addVisual(self)
		game.sound("dragonFire.mp3").play()
		game.onTick(100, "desplazamiento fuego de dragon", {=> self.desplazar()})
		game.schedule(2000, { => game.removeTickEvent("desplazamiento fuego de dragon")})
		game.schedule(2000, { => self.removeVisualSiYaExiste()})
	}

	override method image() {
		return self.toString() + ".png"
	}

	override method enemigoUtilizandolo() {
		return dragon
	}

}

object cannonBall inherits Proyectiles {

	override method lanzar(cannon) {
		self.direccion(right)
		self.position(new MiPosicion(x = cannon.position().x() + 1, y = cannon.position().y()))
		self.image()
		game.addVisual(self)
		game.onTick(70, "desplazamiento bala de cañon", { => self.desplazar()})
		game.schedule(1100, { => game.removeTickEvent("desplazamiento bala de cañon")})
		game.schedule(1100, { => self.removeVisualSiYaExiste()})
	}

	override method teEncontro(objeto) {
		objeto.recibirBala()
		game.sound("cannonBallimpact.mp3").play()
		game.removeVisual(self)
		if (objeto.balasRecibidas() >= 3) {
			objeto.caerHastaLlegarAlSuelo()
			objeto.balasRecibidas(0)
		}
	}

}

// Enemigos:
//Nivel 1
//Pantalla 1
const wolf01 = new Wolf(pantalla = pantalla1, vida = 500, vidaInicial = 500, ataque = 20, defensa = 10, direccion = left, position = new MiPosicion(x = 13, y = 5), nombre = "Wolf", image = left.imagenPersonajeStand("Wolf"), pocionDeVidaAsignada = pocionDe15)

const spectrum01 = new Spectrum(pantalla = pantalla1, vida = 500, vidaInicial = 500, ataque = 20, defensa = 10, direccion = left, position = new MiPosicion(x = 2, y = 1), nombre = "Spectrum", image = left.imagenPersonajeStand("spectrum"), pocionDeVidaAsignada = pocionDe20)

//Pantalla 2
const spectrum02 = new Spectrum(pantalla = pantalla2, vida = 500, vidaInicial = 500, ataque = 20, defensa = 10, direccion = left, position = new MiPosicion(x = 16, y = 5), nombre = "Spectrum", image = left.imagenPersonajeStand("spectrum"), pocionDeVidaAsignada = pocionDe20)

const ogre01 = new Ogre(pantalla = pantalla2, vida = 700, vidaInicial = 700, ataque = 20, defensa = 20, direccion = left, position = new MiPosicion(x = 18, y = 1), nombre = "Ogre", image = left.imagenPersonajeStand("ogre"), pocionDeVidaAsignada = pocionDe25)

//pantalla 3
const wolf02 = new Wolf(pantalla = pantalla3, vida = 500, vidaInicial = 500, ataque = 25, defensa = 10, direccion = left, position = new MiPosicion(x = 11, y = 8), nombre = "Wolf", image = left.imagenPersonajeStand("Wolf"), pocionDeVidaAsignada = pocionDe15)

const spectrum03 = new Spectrum(pantalla = pantalla3, vida = 500, vidaInicial = 500, ataque = 30, defensa = 25, direccion = right, position = new MiPosicion(x = 8, y = 4), nombre = "spectrum", image = right.imagenPersonajeStand("Spectrum"), pocionDeVidaAsignada = pocionDe20)

const ogre02 = new Ogre(pantalla = pantalla3, vida = 700, vidaInicial = 700, ataque = 25, defensa = 30, direccion = right, position = new MiPosicion(x = 5, y = 4), nombre = "Ogre", image = right.imagenPersonajeStand("ogre"), pocionDeVidaAsignada = pocionDe25)

const wolf03 = new Wolf(pantalla = pantalla3, vida = 500, vidaInicial = 500, ataque = 25, defensa = 10, direccion = left, position = new MiPosicion(x = 14, y = 0), nombre = "Wolf", image = left.imagenPersonajeStand("Wolf"), pocionDeVidaAsignada = pocionDe30)

//pantalla 4
const dragon = new Dragon(pantalla = pantalla4, vida = 700, vidaInicial = 700, ataque = 100, defensa = 300, direccion = down, position = new MiPosicion(x = 17, y = 1), nombre = "Dragon", image = down.imagenPersonajeStand("dragon"), pocionDeVidaAsignada = pocionDe30)

////Pantalla 3
//const wolf01 = new Wolf(pantalla = pantalla3,vida = 500,vidaInicial = 500, ataque = 35, defensa = 0, direccion = left, position = new MiPosicion(x = 12, y = 1), nombre = "wolf", image = left.imagenPersonajeStand("wolf"), pocionDeVidaAsignada = pocionDeVida02)
////Pantalla 4
//const wolf02 = new Wolf(pantalla = pantalla4,vida = 500,vidaInicial = 500, ataque = 35, defensa = 0, direccion = left, position = new MiPosicion(x = 12, y = 1), nombre = "wolf", image = left.imagenPersonajeStand("wolf"), pocionDeVidaAsignada = pocionDeVida02)
//const wolf03 = new Wolf(pantalla = pantalla4,vida = 500,vidaInicial = 500, ataque = 35, defensa = 0, direccion = left, position = new MiPosicion(x = 12, y = 1), nombre = "wolf", image = left.imagenPersonajeStand("wolf"), pocionDeVidaAsignada = pocionDeVida02)
////Pantalla 5
//const spectrum03 = new Spectrum(pantalla = pantalla5,vida = 500,vidaInicial = 500, ataque = 20, defensa = 10, direccion = left, position = new MiPosicion(x = 2, y = 5), nombre = "Spectrum", image = left.imagenPersonajeStand("spectrum"), pocionDeVidaAsignada = pocionDeVida01)
//const ogre02 = new Ogre(pantalla = pantalla5,vida = 800,vidaInicial = 800, ataque = 30, defensa = 20, direccion = right, position = new MiPosicion(x = 2, y = 5), nombre = "Ogre", image = right.imagenPersonajeStand("ogre"), pocionDeVidaAsignada = pocionDeVida01)
//const wolf04 = new Wolf(pantalla = pantalla5,vida = 500,vidaInicial = 500, ataque = 35, defensa = 0, direccion = left, position = new MiPosicion(x = 12, y = 1), nombre = "wolf", image = left.imagenPersonajeStand("wolf"), pocionDeVidaAsignada = pocionDeVida02)
