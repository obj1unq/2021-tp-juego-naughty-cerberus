import wollok.game.*
import clases.*
import enemigos.*
import misc.*

object personajePrincipal {
	
	var property vida = 100
	var property energia = 100
	var property ataque = 100
	var property defensa = 1
	var property direccion = right
	var property position = new MiPosicion(x = 0, y = 1)
	var image = direccion.imagenPersonajeStand(self.nombre())

	method image() = image

	method image(imagen) {
		image = imagen
	}

	method nombre() = "personaje"

	method actualizarPosicion(nuevaPosicion) {
		position = nuevaPosicion
	}

	method moverse() {
		direccion.moveMC()
	}

	method esquivar() {
		self.verificarEnergia()
		energia -= 30
		direccion.move(self, 2)
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

	method atacar() { //intentar cambiar la logica del ataque a buscar todos los enemigos a X distancia en vez de al colisionar,ya que da error porque solo interactua con "la punta" del objeto espada
		direccion.atacarMC()
		self.colisionarGolpe(espadaMC)
	}
	method recibirAtaque(danio) {
		self.validarVida(danio)
		vida = vida - self.calculoDeDanio(danio)
	} // la formula actual es: ATK(del MC en este caso) *  (1 - DEF / (100 + DEF))  

	method calculoDeDanio(danio) {
		return danio * (1 - self.defensa() / (100 + self.defensa()))
	}

	method validarVida(danio) {
		if (vida - self.calculoDeDanio(danio) <= 0) {
			self.morir()
		}
	}
	method recibirAtaque() {
		
	}

//	method recibirAtaque(danio) {
//		self.validarVida(danio)
//		vida -= danio
//	}
//
//	method validarVida(danio) {
//		if (vida - danio <= 0) {
//			self.morir()
//		}
//	}

	method morir() {
		game.removeVisual(self)
	}

	method colisionarGolpe(arma) { // me mato yo mismo al atacar? xD quiza con un "if not personaje entonces => recibirataque) se arregla (?
		game.colliders(arma).forEach{ objeto => objeto.recibirAtaque()
		}
	}

	method subirPorEscalera() {
		if (self.hayEscalera()) {
			self.irAlPisoDeArriba()
		} else {
			game.say(self, "no hay escalera para subir")
		}
	}

	method bajarPorEscotilla() {
		if (self.hayEscotilla()) {
			self.irAlPisoDeAbajo()
		} else {
			game.say(self, "no hay escotilla para bajar")
		}
	}

	method hayEscalera() {
		return game.colliders(self).contains(escalera)
	}

	method hayEscotilla() {
		return game.colliders(self).contains(escotilla)
	}

	method irAlPisoDeArriba() {
		self.actualizarPosicion(new MiPosicion(x = self.position().x(), y = self.position().y() + 4))
	}

	method irAlPisoDeAbajo() {
		self.actualizarPosicion(new MiPosicion(x = self.position().x(), y = self.position().y() - 4))
	}

}

object espadaMC{
	//const portador = personajePrincipal
	
	var image = "sword_void.png"
	method image() = image

	method image(imagen) {
		image = imagen
	}
	method position() {
		return new MiPosicion(x = self.mirarHacia() , y = personajePrincipal.position().y())
	}
	method direccion() { return personajePrincipal.direccion()} //revisar esto tmb
	method nombre() = "sword"
	method teEncontro(personaje) {}
	method recibirAtaque() {}
	method recibirAtaque(danio) {}
	method mirarHacia(){
		return 	if(self.direccion() == left) {personajePrincipal.position().x() - 2}
				//else{personajePrincipal.position().x()} // se rompe del lado izquierdo,luego lo reviso
				else {personajePrincipal.position().x()}
	}
}

object left {

	var doubleTap = false

	method moveMC() { // Mov izquierda del MainCharacter (personaje principal)	
	// if(!doubleTap){ // Un pequeño retraso para no spamear botones de movilidad(y hacer más valioso el esquivar)			
		game.schedule(1, { => doubleTap = true})
		runModeL.accion(personajePrincipal, personajePrincipal.direccion())
		game.schedule(100, { => doubleTap = false})
	// }// Esta parte se podria reemplazar por una animacion continua de moverse pero no veo forma de hacerlo viable.
	}

	method move(objeto, num) { // general para cualquier objecto, pensado para usarse en los enemigos
	// objeto.actualizarPosicion(objeto.position().left(num)) // todos los objetos que se muevan deben entender el metodo "actualizarPosicion"
		objeto.position().x(objeto.position().x() - num)
	}

	method imagenPersonajeStand(objeto) {
		return objeto + "_Stand_left.png"
	}
	method imagenPersonajeAttack(objeto){ //probablemente los enemigos melee al igual que el MC tendran problemas al atacar del lado izquierdo
		return objeto + "_Attack_left.png"
	}
	method atacarMC() {
		if (!doubleTap) {
			game.schedule(1, { => doubleTap = true})
			attackMode.accion(espadaMC, personajePrincipal.direccion())
			game.schedule(500, { => doubleTap = false})
		}
	}
 //si llega a haber problemas de rendimiento por atacar muy rapido lo mejor será hacer el ataque de la espada por separado
}

object right {

	var doubleTap = false

	method moveMC() { // Mov derecha del MainCharacter (personaje principal)	
	// if(!doubleTap){ // Un pequeño retraso para no spamear botones de movilidad(y hacer más valioso el esquivar)	(desactivado por ahora mientras se resuelven bugs)		
		game.schedule(1, { => doubleTap = true})
		runModeR.accion(personajePrincipal, personajePrincipal.direccion())
		game.schedule(100, { => doubleTap = false})
	// }// Esta parte se podria reemplazar por una animacion continua de moverse pero no veo forma de hacerlo viable.
	}

	method move(objeto, num) { // general para cualquier objecto, pensado para usarse en los enemigos
		objeto.position().x(objeto.position().x() + num)
	// objeto.actualizarPosicion(objeto.position().right(num)) // todos los objetos que se muevan deben entender el metodo "actualizarPosicion"
	}

	method imagenPersonajeStand(objeto) {
		return objeto + "_Stand_right.png"
	}
	
	method imagenPersonajeAttack(objeto){ //probablemente los enemigos melee al igual que el MC tendran problemas al atacar del lado izquierdo
		return objeto + "_Attack_right.png"
	}

	method atacarMC() {
		if (!doubleTap) {
			game.schedule(1, { => doubleTap = true})
			attackMode.accion(espadaMC, personajePrincipal.direccion())
			game.schedule(500, { => doubleTap = false})
		}
	}
}

object imageNameConversor {

	method getImgName(objeto, accion, direccion, num) {
		objeto.image(objeto.nombre() + "_" + accion + "_" + direccion + "_" + num + ".png")
	}

}

object vacio {

	method imagenVacia() {
		return "void.png"
	}

}

