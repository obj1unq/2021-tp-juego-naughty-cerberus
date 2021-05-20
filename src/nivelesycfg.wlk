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
								personajePrincipal.mirandoA("Left")
								})
		keyboard.d().onPressDo({personajePrincipal.direccion(right)
								personajePrincipal.moverse()
								personajePrincipal.mirandoA("Right")
								})
	}
	
	method recargaEnergia(){
		game.onTick(1000, "recargaEnergia", { personajePrincipal.recargarEnergia() })
	}
}
