import wollok.game.*
import clases.*

object backGround {
	const property position = new MiPosicion(x = 0, y = 0)
	var property fondo = "fondo"
	method image(){return "background_" + fondo + ".png"}
}


//object backGround {
//	const property position = new MiPosicion(x = 0, y = 0)
//	var property image = self.nombreBackground()
//	var property fondo = "fondo"
//
//	method actualizarImagen(){
//		image = self.nombreBackground()
//	}
//	method nombreBackground(){return "background_" + fondo + ".png"}
//}
