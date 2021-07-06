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
//		self.reproducirMusica()            //No se detiene la musica por algun motivo...
		game.addVisual(iniciarJuego)
		game.addVisual(controles)
		game.addVisual(salir)
		game.addVisual(selector)
		game.addVisual(rayo1)
		rayo1.iniciar()
		game.addVisual(rayo2)
		rayo2.iniciar()
		self.controles()		
	}
	method controles(){
		keyboard.up().onPressDo({selector.subir()})
		keyboard.down().onPressDo({selector.bajar()})
		keyboard.del().onPressDo({controles.close() 
		/* Para hacer en un futuro:
		 * La idea es crear luego un objeto que se encargue de manejar el abrir y cerrar ventanas de los menus y dialogos de NPCs y MC, la idea
		 * es hacer una lista que actue como una pila de ventanas a ir cerrando,la ultima que se abrio es la primera 
		 * en cerrarse al darle la orden de cerrar. Cuando se abre una opcion del menu o dialogo este se agrega a la pila el objeto 
		 */
		})
		keyboard.enter().onPressDo({selector.seleccion().iniciar()})
	}
	method reproducirMusica() {
		game.schedule(3000, { => game.sound("sound-MainMenu.mp3").play() })
	}
	method detenerMusica(){
		game.schedule(1, { => game.sound("sound-MainMenu.mp3").stop() })
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
			game.clear()
		//	mainMenu.detenerMusica()
			eventNivel0.iniciar()
	}
}
object controles{
	const property position = new MiPosicion(x = 7, y = 2)
	method image(){return "controles.png"}
	
	method iniciar(){
		rayo1.quitarAnimacion()
		rayo2.quitarAnimacion()
	//	game.addVisual(la pantalla de controles)
	}
	method close(){
	//	game.removeVisual(pantalla de controles)
	}
}
object salir{	
	const property position = new MiPosicion(x = 7, y = 1)
	method image(){return "salir.png"}
	method iniciar(){game.stop()}
}
class Lightning{
	var property direccion = right
	var property image = "void.png"
	var property position
	var property nombre = "lightning"

	method iniciar(){
		game.onTick(4000, self.toString(), { self.animacion().accion(self, self.direccion())})
	}
	method quitarAnimacion(){
		game.removeTickEvent(self.toString())
	}
	method animacion(){
		return new Mode(accion = "Falling", speedFrame = 35, totalImg = 10, time = 0)
	}
}
const rayo1 = new Lightning(position = new MiPosicion(x = 17, y = 2))
const rayo2 = new Lightning(position = new MiPosicion(x = 0, y = 2))