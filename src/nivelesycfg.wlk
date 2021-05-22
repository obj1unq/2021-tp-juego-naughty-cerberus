import wollok.game.*
import personaje.*

object nivel0 {

	method iniciar() {
		game.addVisual(personajePrincipal)
		config.recargaEnergia()
		config.asignarTeclas()
	}

}



object config {
	method asignarTeclas() {
		keyboard.a().onPressDo({personajePrincipal.direccion(left)
								personajePrincipal.moverse()
								})
		keyboard.d().onPressDo({personajePrincipal.direccion(right)
								personajePrincipal.moverse()
								})
		keyboard.j().onPressDo({personajePrincipal.atacar()
								})
		keyboard.k().onPressDo({personajePrincipal.esquivar()
								})
	}
	
	method recargaEnergia(){
		game.onTick(1000, "recargaEnergia", { personajePrincipal.recargarEnergia() })
	}
}
