import wollok.game.*
import clases.*
import background.*

object mainMenu {
	
	method iniciar(){
		backGround.fondo("mainMenu")
		game.addVisual(iniciarJuego)
		game.addVisual(controles)
		game.addVisual(salir)		
	}
	
}

object iniciarJuego{
	
}
object controles{}
object salir{}
