import wollok.game.*
import personaje.*
import enemigos.*
import misc.*
import background.*

object nivel0 {

	method iniciar() {
		game.addVisual(backGround)
		game.addVisual(escotilla)
		game.addVisual(escalera)
		game.addVisual(spectrum01)
		game.addVisual(ogre01)
		game.addVisual(personajePrincipal) // el MC ultimo en cargar así aparece sobre los demás objetos
		game.addVisual(barraDeVidaMC)
		game.addVisual(barraDeVidaOgre)
		game.addVisual(barraDeVidaSpectrum)
		game.addVisual(espadaMC)
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
		keyboard.k().onPressDo({ personajePrincipal.esquivar()})
		keyboard.w().onPressDo({ personajePrincipal.subirPorEscalera()})
		keyboard.s().onPressDo({ personajePrincipal.bajarPorEscotilla()})
		keyboard.del().onPressDo({//window.close() 
		/* La idea es que este objeto se encargue de manejar el abrir y cerrar ventanas de los menus, la idea
		 * es hacer una lista que actue como una pila de ventanas a ir cerrando,la ultima que se abrio es la primera 
		 * en cerrarse al darle la orden de cerrar. Cuando se abre una opcion del menu se agrega a la pila el objeto 
		 */
		})
		keyboard.enter().onPressDo({//window.abrir())
		})
	}

	method recargaEnergia() {
		game.onTick(1000, "recargaEnergia", { personajePrincipal.recargarEnergia()})
	}

	method movimientoEnemigos() {
		spectrum01.recorrerPiso()
		ogre01.recorrerPiso()
	}

	method configurarColisiones() {
		game.onCollideDo(personajePrincipal, { objeto => objeto.teEncontro(personajePrincipal)})
	}

}

