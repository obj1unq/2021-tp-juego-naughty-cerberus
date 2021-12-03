import wollok.game.*
import clases.*

object backGround inherits ObjetosInteractuables{

	const property position = new MiPosicion(x = 0, y = 0)
	var property fondo = "fondo"

	method image() {
		return "background_" + fondo + ".png"
	}

}

