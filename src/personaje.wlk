import wollok.game.*

object personajePrincipal {

	var property vida = 100
	var property energia = 100
	var property direccion = right
	var property mirandoA = "Right"
	var property position = game.at(0, 1)

	method image() = direccion.imagenPersonaje()

	method moverse(nuevaPosicion) {
		position = nuevaPosicion
	}
	
	
	
	method orientacionEsquivar(){	// Hacia donde está mirando el personaje
		if (mirandoA == "Right"){
			return self.position().right(2)
		}
		else {
			return self.position().left(2)
		}
	}		
	
	method esquivar(nuevaPosicion) {
		self.verificarEnergia()
		energia -= 10
		position = nuevaPosicion
	}

	method verificarEnergia() {
		if (energia < 20) {
			self.error("No tengo energia para esquivar")
		}
	}

	method recargarEnergia() {
		// recarga 10 de energia (la idea es que sea cada segundo)
		energia = (energia + 10).min(100)

	}

}
object left{
	
	method movimiento(objeto,num){
		objeto.position().left(num)
		}
	method imagenPersonaje(){
		return "personaje_Stand_Left.png"
	}
}

object right{
	
	method movimiento(objeto,num){
		objeto.position().right(num)
		}
	method imagenPersonaje(){
		return "personaje_Stand_Right.png"
	}
}