import wollok.game.*

object personajePrincipal {

	var property vida = 100
	var property energia = 100
	var property direccion = right
	var property mirandoA = "Right"
	var property position = game.at(0, 1)

	method image() = direccion.imagenPersonaje()

	method actualizarPosicion(nuevaPosicion) {
		position = nuevaPosicion
	}
	method moverse(){
		direccion.moveMC()
	}
	
	
	method esquivar(nuevaPosicion) {
		self.verificarEnergia()
		energia -= 30
		self.actualizarPosicion(nuevaPosicion)
	}

	method verificarEnergia() {
		if (energia < 30) {
			self.error("No tengo energia para esquivar")
		}
	}

	method recargarEnergia() {
		// recarga 10 de energia (la idea es que sea cada segundo)
		energia = (energia + 10).min(100)

	}
  
}
object left{
	var doubleTap = false
	
	method moveMC(){  // Mov izquierda del MainCharacter (personaje principal)	
		if(doubleTap){ 			// Accion de esquivar
				personajePrincipal.esquivar(personajePrincipal.position().left(2)) 
				}// Esta parte se podria reemplazar por una animacion continua de moverse y volver a usar otra tecla para esquivar
		else{	
				game.schedule(1, { => doubleTap = true })
				personajePrincipal.actualizarPosicion(personajePrincipal.position().left(0.5))
				game.schedule(100, { => doubleTap = false })
				}
		}
	
	
	method move(objeto,num){ // general para cualquier objecto, pensado para usarse en los enemigos
		objeto.actualizarPosicion(objeto.position().left(num)) // todos los objetos que se muevan deben entender el metodo "actualizarPosicion"
		}
	method imagenPersonaje(){
		return "personaje_Stand_Left.png"
	}
}

object right{
	var doubleTap = false
	
	method moveMC(){  // Mov izquierda del MainCharacter (personaje principal)	
		if(doubleTap){ 			// Accion de esquivar
				personajePrincipal.esquivar(personajePrincipal.position().right(2))  
				}// Esta parte se podria reemplazar por una animacion continua de moverse y volver a usar otra tecla para esquivar
		else{	
				game.schedule(1, { => doubleTap = true })
				personajePrincipal.actualizarPosicion(personajePrincipal.position().right(0.5))
				game.schedule(100, { => doubleTap = false })
				}
		}
	
	method move(objeto,num){ // general para cualquier objecto, pensado para usarse en los enemigos
		objeto.actualizarPosicion(objeto.position().right(num)) // todos los objetos que se muevan deben entender el metodo "actualizarPosicion"
		}
		
	method imagenPersonaje(){
		return "personaje_Stand_Right.png"
	}
	
}