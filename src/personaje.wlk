import wollok.game.*
import clases.*

object personajePrincipal {

	var property vida = 100
	var property energia = 100
	var property direccion = right
	var property position = game.at(0, 1)
	var image = direccion.imagenPersonaje()

	method image() = image // posteriormente "image"
	
	method image(imagen){
		image = imagen
	}
	
	method nombre() = "personaje"
	
	method actualizarPosicion(nuevaPosicion) {
		position = nuevaPosicion
	}
	method moverse(){
		direccion.moveMC()
	}
	
	
	method esquivar() {
		self.verificarEnergia()
		energia -= 30
		direccion.move(self,2)
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
  	
  	method atacar(){
  		
  	}
}
object left{
	var doubleTap = false
	
	method moveMC(){  // Mov izquierda del MainCharacter (personaje principal)	
		if(!doubleTap){ // Un pequeño retraso para no spamear botones de movilidad(y hacer más valioso el esquivar)			
				game.schedule(1, { => doubleTap = true })
				runModeL.accion(personajePrincipal,personajePrincipal.direccion())
				game.schedule(100, { => doubleTap = false })
				}// Esta parte se podria reemplazar por una animacion continua de moverse pero no veo forma de hacerlo viable.
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
	
	method moveMC(){  // Mov derecha del MainCharacter (personaje principal)	
		if(!doubleTap){ // Un pequeño retraso para no spamear botones de movilidad(y hacer más valioso el esquivar)			
				game.schedule(1, { => doubleTap = true })
				runModeR.accion(personajePrincipal,personajePrincipal.direccion())
				game.schedule(100, { => doubleTap = false })
				}// Esta parte se podria reemplazar por una animacion continua de moverse pero no veo forma de hacerlo viable.
		}
	
	method move(objeto,num){ // general para cualquier objecto, pensado para usarse en los enemigos
		objeto.actualizarPosicion(objeto.position().right(num)) // todos los objetos que se muevan deben entender el metodo "actualizarPosicion"
	}
		
	method imagenPersonaje(){
		return "personaje_Stand_Right.png"
	}
	
}
object imageNameConversor {

	method getImgName(objeto, accion,direccion, num) {
		objeto.image(objeto.nombre() + "_"  + accion + "_" + direccion + "_" + num + ".png")
	}
}