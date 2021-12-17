import wollok.game.*
import clases.*
import background.*
import personaje.*
import enemigos.*
import nivelesycfg.*
import musica.*
import misc.*

object mainMenu {

	method iniciar() {
		backGround.fondo("mainMenu")
		game.addVisual(backGround)
		self.reproducirMusica()
		//game.addVisual(raining)
		//raining.iniciar()
		game.addVisual(iniciarJuego)
		game.addVisual(controles)
		game.addVisual(salir)
		game.addVisual(selector)
		game.addVisual(rayo1)
		rayo1.iniciar()
		game.addVisual(rayo2)
		rayo2.iniciar()
		game.addVisual(errorReporter)
		game.errorReporter(errorReporter)
		self.controles()
	}

	method controles() {
		keyboard.w().onPressDo({ selector.subir()})
		keyboard.s().onPressDo({ selector.bajar()})
		keyboard.del().onPressDo({ controles.close()
		/* Para hacer en un futuro:
		 * La idea es crear luego un objeto que se encargue de manejar el abrir y cerrar ventanas de los menus y dialogos de NPCs y MC, la idea
		 * es hacer una lista que actue como una pila de ventanas a ir cerrando,la ultima que se abrio es la primera 
		 * en cerrarse al darle la orden de cerrar. Cuando se abre una opcion del menu o dialogo este se agrega a la pila el objeto 
		 */
		})
		keyboard.enter().onPressDo({ selector.seleccion().iniciar()})
	}

	method reproducirMusica() {
		game.schedule(1000, { => soundMainMenu.play()})
	}

	method detenerMusica() {
		soundMainMenu.stop()
	}

}

object selector {

	var opciones = [ iniciarJuego, controles, salir ]
	const property image = "selector.png"

	method position() {
		return new MiPosicion(x = self.seleccion().position().x(), y = self.seleccion().position().y())
	}

	method seleccion() = opciones.head()

	method bajar() {
		const seleccionActual = self.seleccion()
		opciones.remove(seleccionActual)
		opciones.add(seleccionActual)
	}

	method subir() {
		const ultimaSeleccion = opciones.last()
		opciones.remove(ultimaSeleccion)
		opciones = [ ultimaSeleccion ] + opciones
	}

}

object iniciarJuego {

	const property position = new MiPosicion(x = 7, y = 3)

	method image() {
		return "iniciarJuego.png"
	}

	method iniciar() {
		mainMenu.detenerMusica()
		game.clear()
		eventHistoria.iniciar()
	}

}

object controles {

	const property position = new MiPosicion(x = 7, y = 2)

	method image() {
		return "controles.png"
	}

	method iniciar() {
		game.addVisual(menuControles)
		game.addVisual(errorReporter)
		game.errorReporter(errorReporter)
	}

	method close() {
		game.removeVisual(menuControles)
	}

}

object salir {

	const property position = new MiPosicion(x = 7, y = 1)

	method image() {
		return "salir.png"
	}

	method iniciar() {
		game.stop()
	}

}

class Lightning {

	var property direccion = right
	var property image = "void.png"
	var property position
	var property nombre = "lightning"
	var property sigueEnAccion = false

	method iniciar() {
		game.onTick(4000, self.toString(), { self.animacion().accion(self, self.direccion())})
	}

	method quitarAnimacion() {
		game.removeTickEvent(self.toString())
	}

	method animacion() {
		return new Mode(accion = "falling", speedFrame = 35, totalImg = 10, time = 0)
	}
	method standPositionImage(){
		return "void.png"
	}
}

object raining {
	var property direccion = right
	var property image = "void.png"
	var property position = new MiPosicion(x = 0, y = 0)
	var property nombre = "raining"
	
	method iniciar() {
		game.schedule(3000, {=> game.onTick(905, self.toString(), { self.animacion().accion(self, self.direccion())})})
	}

	method quitarAnimacion() {
		game.removeTickEvent(self.toString())
	}

	method animacion() {
		return new Mode(accion = "falling", speedFrame = 100, totalImg = 9, time = 0)
	}
}

//object selectorEspada{
//	var opciones = [yes,no]
//	
//	const property image = "sel_espada.png"
//	
//	method position() {
//		return new MiPosicion(x = self.seleccion().position().x()-1 , y = self.seleccion().position().y())		
//		}
//		
//	method seleccion() = opciones.head()
//	
//	method derecha(){
//		const seleccionActual = self.seleccion()
//		opciones.remove(seleccionActual)
//		opciones.add(seleccionActual)
//		
//		}
//	method izquierda(){
//		const ultimaSeleccion = opciones.last()
//		opciones.remove(ultimaSeleccion)
//		opciones = [ultimaSeleccion] + opciones		
//	}
//}
object menuControles {

	const property position = new MiPosicion(x = 0, y = 0)

	method image() {
		return "background_controles.png"
	}

}

object endMenu {

	method iniciar() {
		game.clear()
		backGround.fondo("gameover")
		game.addVisual(backGround)
		self.terminarJuego()
//		game.addVisual(yes)
//		game.addVisual(no)
//		game.addVisual(selectorEspada)
//		self.controles()
	}

	method terminarJuego() {
		game.schedule(3000, {=> game.stop()})
	}

//	method controles(){
//		keyboard.left().onPressDo({selectorEspada.izquierda()})
//		keyboard.right().onPressDo({selectorEspada.derecha()})
//		keyboard.enter().onPressDo({selectorEspada.seleccion().iniciar()})
//	}
}

//object yes{
//	const property position = new MiPosicion(x = 8, y = 3)
//	method image(){return "yes.png"}
//	
//	method iniciar(){
//		game.clear()
//		personajePrincipal.actualizarPosicion(new MiPosicion(x = 0, y = 1))
//		personajePrincipal.direccion(right)
//		personajePrincipal.actualizarImagen()
//		personajePrincipal.vida(100)
//		eventNivel0.iniciar()
//		//TODO: REINICIAR ENEMIGOS
//		
//	}
//}
//
//object no{
//	const property position = new MiPosicion(x = 11, y = 3)
//	method image(){return "no.png"}
//	
//	method iniciar(){
//		game.stop()
//	}
//}
const rayo1 = new Lightning(position = new MiPosicion(x = 17, y = 2))

const rayo2 = new Lightning(position = new MiPosicion(x = 0, y = 2))


