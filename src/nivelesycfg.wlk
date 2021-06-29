import wollok.game.*
import personaje.*
import enemigos.*
import misc.*
import background.*

object ajustesIniciales {

	method iniciar() {
		config.asignarTeclas()
		config.movimientoEnemigos()
		config.recargaEnergia()
		config.configurarColisiones()
	}

}

object nivel0 {

	method iniciar() {
		backGround.fondo("fondo")
		game.addVisual(escotilla)
		game.addVisual(escalera)
		game.addVisual(spectrum01)
		game.addVisual(wolf01)
//		game.addVisual(ogre01)
		game.addVisual(personajePrincipal) // el MC ultimo en cargar así aparece sobre los demás objetos
		game.addVisual(barraDeVidaMC)
		game.addVisual(spectrum01.barraDeVida())
		game.addVisual(wolf01.barraDeVida())
//		game.addVisual(ogre01.barraDeVida())
//		game.addVisual(spectrum01.barraDeVida())
		game.addVisual(espadaMC)
		ajustesIniciales.iniciar()
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
	}

	method recargaEnergia() {
		game.onTick(1000, "recargaEnergia", { personajePrincipal.recargarEnergia()})
	}

	method movimientoEnemigos() {
		spectrum01.vigilarPiso()
		wolf01.vigilarPiso()
//		ogre01.vigilarPiso()
	}

	method configurarColisiones() {
		game.onCollideDo(personajePrincipal, { objeto => objeto.teEncontro(personajePrincipal)})
	}

}

