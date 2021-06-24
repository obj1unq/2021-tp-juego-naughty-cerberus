import wollok.game.*
import clases.*
import background.*
import personaje.*
import enemigos.*
import nivelesycfg.*

object mainMenu {
	
	method iniciar(){
		backGround.fondo("mainMenu")
		game.addVisual(backGround)
		game.addVisual(iniciarJuego)
		game.addVisual(controles)
		game.addVisual(salir)
		game.addVisual(selector)
		self.controles()		
	}
	method controles(){
		keyboard.up().onPressDo({selector.subir()})
		keyboard.down().onPressDo({selector.bajar()})
		keyboard.del().onPressDo({//objeto.close() 
		/* La idea es que este objeto se encargue de manejar el abrir y cerrar ventanas de los menus, la idea
		 * es hacer una lista que actue como una pila de ventanas a ir cerrando,la ultima que se abrio es la primera 
		 * en cerrarse al darle la orden de cerrar. Cuando se abre una opcion del menu se agrega a la pila el objeto 
		 */
		})
		keyboard.enter().onPressDo({selector.seleccion().iniciar()})
	}
}

object selector{
	var opciones = [iniciarJuego,controles,salir]
	
	const property image = "selector.png"
	method position() {
		return new MiPosicion(x = self.seleccion().position().x() , y = self.seleccion().position().y())
		
		}
	method seleccion() = opciones.head()
	
	method bajar(){
		const seleccionActual = self.seleccion()
		opciones.remove(seleccionActual)
		opciones.add(seleccionActual)
	}
	method subir(){
		const ultimaSeleccion = opciones.last()
		opciones.remove(ultimaSeleccion)
		opciones = [ultimaSeleccion] + opciones		
	}
}

object iniciarJuego{
	const property position = new MiPosicion(x = 7, y = 3)
	method image(){return "iniciarJuego.png"}
	
	method iniciar(){
			game.removeVisual(self)
			game.removeVisual(controles)
			game.removeVisual(salir)
			game.removeVisual(selector)
			nivel0.iniciar()
	}
}
object controles{
	const property position = new MiPosicion(x = 7, y = 2)
	method image(){return "controles.png"}
	
	method iniciar(){
		//T0D0
	}
}
object salir{	
	const property position = new MiPosicion(x = 7, y = 1)
	method image(){return "salir.png"}
	method iniciar(){game.stop()}
	}
