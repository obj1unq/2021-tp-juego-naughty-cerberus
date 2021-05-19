import wollok.game.*
import personaje.*

object nivel0 {

	method iniciar() {
		game.addVisual(personajePrincipal)
		game.onTick(500, "recargar Energia", { => personajePrincipal.recargarEnergia()})
		config.asignarTeclas()
	}

}


object config {
	method asignarTeclas() {
		keyboard.a().onPressDo({personajePrincipal.moverse(personajePrincipal.position().left(0.5))})
		keyboard.d().onPressDo({personajePrincipal.moverse(personajePrincipal.position().right(0.5))})
		keyboard.j().onPressDo({personajePrincipal.esquivar(personajePrincipal.position().left(1))})
	}
	
	
}
