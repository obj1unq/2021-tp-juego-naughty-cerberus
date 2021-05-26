import wollok.game.*
import personaje.*
import enemigos.*

object nivel0 {

	method iniciar() {
		game.addVisual(spectrum01)
		game.addVisual(personajePrincipal) // el MC ultimo en cargar así aparece sobre los demás objetos
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
	
	method movimientoEnemigos() {
		spectrum01.perseguirMC()
	}
}
