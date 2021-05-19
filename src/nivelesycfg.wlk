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
		keyboard.a().onPressDo({personajePrincipal.moverse(personajePrincipal.position().left(0.5))
								personajePrincipal.mirandoA("Left")})
		keyboard.d().onPressDo({personajePrincipal.moverse(personajePrincipal.position().right(0.5))
								personajePrincipal.mirandoA("Right")})
		keyboard.j().onPressDo({personajePrincipal.esquivar(personajePrincipal.orientacionEsquivar())})
	}
	
	method recargaEnergia(){
		game.onTick(1000, "recargaEnergia", { personajePrincipal.recargarEnergia() })
	}
}
