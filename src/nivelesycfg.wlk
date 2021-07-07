import wollok.game.*
import personaje.*
import enemigos.*
import misc.*
import background.*
import clases.*
import musica.*

object ajustesIniciales {

	method iniciar() {
		config.asignarTeclas()
		config.recargaEnergia()
		self.ajustesBasicos()
//				config.agregarGravedad()
	}

	method ajustesBasicos() {
		config.configurarColisiones()
	}

}

object eventHistoria {

	method iniciar() {
		backGround.fondo("historia")
		game.addVisual(backGround)
		self.teclaContinuar()
		self.reproducirMusica()
	}

	method close() {
		self.detenerMusica()
		game.clear()
		eventNivel0.iniciar()
	}

	method teclaContinuar() {
		keyboard.enter().onPressDo({ self.close()})
	}

	method reproducirMusica() {
		game.schedule(300, { => soundHistoria.play()})
	}

	method detenerMusica() {
		soundHistoria.stop()
	}

}

object eventNivel0 {

	method iniciar() {
		backGround.fondo("nivel1_2")
		game.addVisual(backGround)
		game.addVisual(personajePrincipal)
		game.addVisual(tpTunelAbajo)
		ajustesIniciales.ajustesBasicos()
		game.schedule(2000, { => 12.times({ i => personajePrincipal.moverse()})})
			// game.say(personajePrincipal, "DEBO SALVAR A MI FAMILIA CUANTO ANTES!")
		game.say(personajePrincipal, "DEBO SALVAR A MI")
		game.say(personajePrincipal, "MI FAMILIA CUANTO ANTES!")
	}

}

class Nivel1 {

	method iniciar() {
		self.agregarEnemigos()
		self.agregarBarrasDeVidaEnemigos()
		game.addVisual(personajePrincipal) // el MC ultimo en cargar así aparece sobre los demás objetos
		game.addVisual(barraDeVidaMC)
		game.addVisual(espadaMC)
		self.agregarBloqueos()
		self.movimientoEnemigos()
		self.agregarTPs()
		ajustesIniciales.iniciar()
	}

	method agregarEnemigos() {
	}

	method agregarBarrasDeVidaEnemigos() {
	}

	method movimientoEnemigos() {
	}

	method agregarBloqueos() {
	}

	method agregarTPs() {
	}

}

object nivelDragon {

	method iniciar() {
		backGround.fondo("nivelDragon")
	}

}

object pantalla1 inherits Nivel1 {

	var property enemigos = [ spectrum01, wolf01 ]

	override method iniciar() {
		config.agregarGravedad()
		backGround.fondo("nivel1_5")
		game.addVisual(backGround)
		game.addVisual(escotilla01)
		game.addVisual(escalera01)
		super()
	}

	override method agregarBloqueos() {
		game.addVisual(bloqueoIzquierdaArriba)
		game.addVisual(bloqueoIzquierdaAbajo)
		game.addVisual(bloqueoDerechaArriba)
	}

	override method agregarTPs() {
		game.addVisual(tpPantalla2)
	}

	override method agregarEnemigos() {
		enemigos.forEach({ enemigo => game.addVisual(enemigo)})
	}

	override method agregarBarrasDeVidaEnemigos() {
		enemigos.forEach({ enemigo => game.addVisual(enemigo.barraDeVida())})
	}

	override method movimientoEnemigos() {
		enemigos.forEach({ enemigo => enemigo.vigilarPiso()})
	}

}

object pantalla2 inherits Nivel1 {

	var property enemigos = [ spectrum02, ogre01 ]

	override method iniciar() {
		backGround.fondo("nivel1_6")
		game.addVisual(backGround)
		game.addVisual(escotilla02)
		game.addVisual(escalera02)
		super()
	}

	override method agregarTPs() {
		game.addVisual(tpRegresoPantalla1)
		game.addVisual(tpPantalla3)
//		game.addVisual(tpPantalla4)
//		game.addVisual(tpBossAlternativo)
	}

	override method agregarEnemigos() {
		enemigos.forEach({ enemigo => game.addVisual(enemigo)})
	}

	override method agregarBarrasDeVidaEnemigos() {
		enemigos.forEach({ enemigo => game.addVisual(enemigo.barraDeVida())})
	}

	override method movimientoEnemigos() {
		enemigos.forEach({ enemigo => enemigo.vigilarPiso()})
	}

}

object pantalla3 inherits Nivel1 {

	var property enemigos = []

	override method iniciar() {
		backGround.fondo("nivel1_7")
		game.addVisual(backGround)
		game.addVisual(escalera03)
		game.addVisual(escalera04)
		game.addVisual(escotilla03)
		game.addVisual(escotilla04)
		super()
	}

	override method agregarTPs() {
		game.addVisual(tpRegresoPantalla2)
		game.addVisual(tpPantalla4)
//		game.addVisual(tpPantalla4)
//		game.addVisual(tpBossAlternativo)
	}

	override method agregarEnemigos() {
		enemigos.forEach({ enemigo => game.addVisual(enemigo)})
	}

	override method agregarBarrasDeVidaEnemigos() {
		enemigos.forEach({ enemigo => game.addVisual(enemigo.barraDeVida())})
	}

	override method movimientoEnemigos() {
		enemigos.forEach({ enemigo => enemigo.vigilarPiso()})
	}

}

object pantalla4 inherits Nivel1 {

	var property enemigos = [ dragon ]

	override method iniciar() {
		backGround.fondo("nivelDragon")
		game.addVisual(backGround)
		game.addVisual(escalera05)
		game.addVisual(escalera06)
		game.addVisual(escotilla05)
		game.addVisual(escotilla06)
		game.addVisual(cannon01)
		game.addVisual(cannon02)
		game.addVisual(cannon03)
		game.addVisual(cajaDeBalas)
		game.addVisual(bloqueoDerechaArribaDragon)
		game.addVisual(bloqueoDerechaMedioDragon)
//		game.addVisual(escotilla)
//		game.addVisual(escalera)
		super()
//		config.configurarColisionesDragon()
	}

	override method agregarTPs() {
		game.addVisual(tpRegresoPantalla3)
		game.addVisual(bloqueoBordeCannon02)
		game.addVisual(bloqueoBordeCannon03)
		game.addVisual(bloqueoEnElDragon)
//		game.addVisual(tpPantalla3)
//		game.addVisual(tpPantalla4)
//		game.addVisual(tpBossAlternativo)
	}

	override method agregarEnemigos() {
		enemigos.forEach({ enemigo => game.addVisual(enemigo)})
		game.onCollideDo(dragon, { objeto => objeto.teEncontro(dragon)})
	}

	override method agregarBarrasDeVidaEnemigos() {
		enemigos.forEach({ enemigo => game.addVisual(enemigo.barraDeVida())})
	}

	override method movimientoEnemigos() {
		enemigos.forEach({ enemigo => enemigo.vigilarPiso()})
	}

}

object config {

	method asignarTeclas() {
		keyboard.a().onPressDo({ personajePrincipal.direccion(left)
			personajePrincipal.moverse()
		})
		keyboard.d().onPressDo({ personajePrincipal.direccion(right)
			personajePrincipal.moverse()
		})
		keyboard.j().onPressDo({ personajePrincipal.atacar()})
		keyboard.k().onPressDo({ personajePrincipal.bloquear()})
//		keyboard.w().onPressDo({ personajePrincipal.subirPorEscalera()})
//		keyboard.s().onPressDo({ personajePrincipal.bajarPorEscotilla()})
		keyboard.i().onPressDo({ personajePrincipal.decirPos()})
		keyboard.w().onPressDo({ personajePrincipal.subirSiHayEscalera()})
		keyboard.s().onPressDo({ personajePrincipal.bajarSiHayEscotilla()})
		keyboard.r().onPressDo({ personajePrincipal.agarrarBalaOCargarCannon()})
		keyboard.f().onPressDo({ personajePrincipal.dispararCannon()})
	}

	method recargaEnergia() {
		game.onTick(1000, "recargaEnergia", { personajePrincipal.recargarEnergia()})
	}

	method configurarColisiones() {
		game.onCollideDo(personajePrincipal, { objeto => objeto.teEncontro(personajePrincipal)})
	}

	method agregarGravedad() {
		game.onTick(300, "GRAVEDAD", { personajePrincipal.caerSiNoEstasEnPiso()})
	}

}

