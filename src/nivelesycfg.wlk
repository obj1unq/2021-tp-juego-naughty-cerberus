import wollok.game.*
import personaje.*
import enemigos.*
import misc.*
import background.*
import clases.*

object ajustesIniciales {

	method iniciar() {
		config.asignarTeclas()
		config.recargaEnergia()
		config.agregarGravedad()
		self.ajustesBasicos()
	}
	method ajustesBasicos(){
		config.configurarColisiones()
	}
}
object eventNivel0{
	
	method iniciar(){
		backGround.fondo("nivel1_2")
		game.addVisual(personajePrincipal)
		game.addVisual(tpTunelAbajo)
		ajustesIniciales.ajustesBasicos()
		game.schedule(2000, { => 12.times({i => personajePrincipal.moverse()}) })
		//game.say(personajePrincipal, "DEBO SALVAR A MI FAMILIA CUANTO ANTES!")
		game.say(personajePrincipal, "DEBO SALVAR A MI")
		game.say(personajePrincipal, "MI FAMILIA CUANTO ANTES!")
		
		
	}
}
object nivel1 {
	method iniciar() {
		pantalla1.iniciar()
	}
}

object pantalla1{
	var property enemigos = [spectrum01]		
	
	method iniciar(){
		backGround.fondo("nivel1_5")
		game.addVisual(backGround)
		game.addVisual(escotilla)
		game.addVisual(escalera)
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
	
	method agregarEnemigos(){
		enemigos.forEach({enemigo => game.addVisual(enemigo)})
	}
	method agregarBarrasDeVidaEnemigos(){
		enemigos.forEach({enemigo => game.addVisual(enemigo.barraDeVida())})
	}

	method movimientoEnemigos() {
		enemigos.forEach({enemigo => enemigo.vigilarPiso()})
	}
	method agregarBloqueos(){
		game.addVisual(bloqueoIzquierdaArriba)
		game.addVisual(bloqueoIzquierdaAbajo)
		game.addVisual(bloqueoDerechaArriba)
	}
	method agregarTPs(){
		game.addVisual(tpPantalla2)
	}
}
object pantalla2{
	var property enemigos = [spectrum02,ogre01]		
	
	method iniciar(){
		backGround.fondo("nivel1_6")
		game.addVisual(backGround)
		game.addVisual(escotilla)
		game.addVisual(escalera)
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
	
	method agregarEnemigos(){
		enemigos.forEach({enemigo => game.addVisual(enemigo)})
	}
	method agregarBarrasDeVidaEnemigos(){
		enemigos.forEach({enemigo => game.addVisual(enemigo.barraDeVida())})
	}

	method movimientoEnemigos() {
		enemigos.forEach({enemigo => enemigo.vigilarPiso()})
	}
	method agregarBloqueos(){
	}
	method agregarTPs(){
		game.addVisual(tpRegresoPantalla1)
//		game.addVisual(tpPantalla3)
//		game.addVisual(tpPantalla4)
//		game.addVisual(tpBossAlternativo)
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
		keyboard.w().onPressDo({ personajePrincipal.subirPorEscalera()})
		keyboard.s().onPressDo({ personajePrincipal.bajarPorEscotilla()})
		keyboard.i().onPressDo({ personajePrincipal.decirPos()})
	}

	method recargaEnergia(){
	game.onTick(1000, "recargaEnergia", { personajePrincipal.recargarEnergia()})
	}
	method configurarColisiones() {
		game.onCollideDo(personajePrincipal, { objeto => objeto.teEncontro(personajePrincipal)})
	}
	method agregarGravedad() {
		game.onTick(300, "GRAVEDAD", { personajePrincipal.caerSiNoEstasEnPiso()})
	}
}

