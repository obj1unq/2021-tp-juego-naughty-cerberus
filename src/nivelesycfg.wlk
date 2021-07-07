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
		game.schedule(50, { => soundHistoria.play()})
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
		game.say(personajePrincipal, "FAMILIA CUANTO ANTES!")
		self.reproducirMusica()
	}

	method reproducirMusica() {
		game.schedule(50, { =>
			soundGameplay.play()
			soundGameplay.shouldLoop(true)
		})
	}

	method detenerMusica() {
		soundGameplay.stop()
	}

}

class Nivel1 {

	method iniciar() {
		self.agregarEnemigos()
		self.agregarBarrasDeVidaEnemigos()
		game.addVisual(personajePrincipal) // el MC ultimo en cargar así aparece sobre los demás objetos
		game.addVisual(barraDeVidaMC)
		game.addVisual(barraDeEnergiaMC)
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
		game.addVisual(tpWulgrym)
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

object wulgrymEncuentro inherits Nivel1 {

	override method iniciar() {
		backGround.fondo("nivel1_1")
		game.addVisual(backGround)
		game.addVisual(wulgrym)
		super()
	}

	override method agregarTPs() {
		game.addVisual(tpWulgrymRegresoPantalla2)
	}

	override method agregarBloqueos() {
		game.addVisual(bloqueoIzquierdaAbajo)
	}

}

object pantalla3 inherits Nivel1 {

	var property enemigos = [ wolf02, spectrum03, ogre02, wolf03 ]

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
		game.addVisual(errorReporter)
		game.errorReporter(errorReporter)
//		game.addVisual(escotilla)
//		game.addVisual(escalera)
		super()
		self.reproducirMusica()
//		config.configurarColisionesDragon()
	}

	override method agregarTPs() {
		// game.addVisual(tpRegresoPantalla3)  este tp es mejor que no esté asi no pueden salir de la sala del boss
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

	method reproducirMusica() {
		game.schedule(50, { =>
			if (soundGameplay.played()) {
				eventNivel0.detenerMusica()
			}
			soundBoss.play()
			soundBoss.shouldLoop(true)
		})
	}

	method detenerMusica() {
		soundBoss.stop()
	}

}

object eventFinal {

	method iniciar() {
		self.reproducirMusica()
		game.addVisual(firstWhisperDialog)
		firstWhisperDialog.configurarDialogo()
	}

	method reproducirMusica() {
		game.schedule(25, { =>
			soundWhispers.play()
			if (soundBoss.played()) {
				pantalla4.detenerMusica()
			}
		})
	}

	method detenerMusica() {
		soundWhispers.stop()
	}

}

object firstWhisperDialog {

	var property position = new MiPosicion(x = 0, y = 0)

	method image() {
		return "dialog_MC_final.png"
	}

	method configurarDialogo() {
		keyboard.enter().onPressDo({ credits.iniciar()})
	}

	method teEncontro(objeto) {
	}

	method recibirAtaque() {
	}

	method recibirAtaque(danio) {
	}

	method recibirDanio() {
	}

	method recibirDanio(cantidad) {
	}

}

object credits {

	method iniciar() {
		game.clear()
		backGround.fondo("creditos")
		game.addVisual(backGround)
		game.schedule(10000, {=> game.stop()})
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

