import wollok.game.*
import personaje.*
import enemigos.*
import misc.*

object nivel0 {

	method iniciar() {
		game.addVisual(spectrum02)
		game.addVisual(escalera)
		game.addVisual(escotilla)
		game.addVisual(personajePrincipal) // el MC ultimo en cargar así aparece sobre los demás objetos

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
		keyboard.w().onPressDo({personajePrincipal.subirPorEscalera()
								})
		keyboard.s().onPressDo({personajePrincipal.bajarPorEscotilla()
								})								

	}
	

	
	method recargaEnergia() {
		game.onTick(1000, "recargaEnergia", { personajePrincipal.recargarEnergia() })
		
	}
	
	method movimientoEnemigos() {
		spectrum02.recorrerPiso()
	}
	
	method configurarColiciones() {
		game.onCollideDo(personajePrincipal, {objeto => objeto.teEncontro(personajePrincipal)})
	}
}
