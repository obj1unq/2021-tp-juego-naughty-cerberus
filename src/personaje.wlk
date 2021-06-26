import wollok.game.*
import clases.*
import enemigos.*
import misc.*

object personajePrincipal {

	var property vida = 100
	var property energia = 100
	var property ataque = 100
	var property defensa = 20
	var property direccion = right
	var property position = new MiPosicion(x = 0, y = 1)
	var property nombre = "personaje"
	var property blockStance = false
	var property doubleTap = false
	var image = direccion.imagenPersonajeStand(self.nombre())

	method image() = image

	method image(imagen) {
		image = imagen
	}

	method actualizarImagen() {
		self.image(direccion.imagenPersonajeStand(nombre.toString()))
	}

//	method nombre() = "personaje"
	method actualizarPosicion(nuevaPosicion) {
		position = nuevaPosicion
	}

	method moverse() {
		if(not self.blockStance()){direccion.moveMC()}
	}

	method bloquear() {
		self.verificarEnergia()
		energia -= 25
		self.modoBloqueo()
		game.schedule(500, { => self.salirDeModoBloqueo()})
	}

	method modoBloqueo() {
		if(not self.blockStance()){
			blockStance = true
			self.image(direccion.imagenPersonajeBlock(self.nombre()))
			defensa = defensa * 2
		
		}
	}

	method salirDeModoBloqueo() {
		blockStance = false
		self.actualizarImagen()
		defensa = defensa / 2
	}

	method verificarEnergia() {
		if (energia < 25) {
			self.error("No tengo energia para bloquear")
		}
	}

	method recargarEnergia() {
		// recarga 10 de energia (la idea es que sea cada segundo)
		energia = (energia + 10).min(100)
	}

	method atacar() {
		if (not doubleTap and not self.blockStance()) {
			game.schedule(1, { => doubleTap = true})
			self.realizarAtaque()
			self.colisionarGolpe()
			}
	}
	method realizarAtaque(){
		
		attackMode.accion(espadaMC, self.direccion())
		game.schedule(500, { => doubleTap = false})
		
	}
	method recibirAtaque(danio) {
		self.validarVida(danio)
		vida = vida - self.calculoDeDanio(danio)
	} // la formula actual es: ATK(del MC en este caso) *  (1 - DEF / (100 + DEF))  
		//
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

	method morir() {
		game.removeVisual(self)
	}

	method colisionarGolpe() {
		direccion.obtenerObjetosParaAtacar(self,2)
		direccion.objetivos().forEach{objeto => objeto.recibirAtaque()}
		direccion.objetivos(#{})
		
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

object espadaMC {

	// const portador = personajePrincipal
	var image = "sword_void.png"

	method image() = image

	method image(imagen) {
		image = imagen
	}

	method position() {
		return new MiPosicion(x = self.mirarHacia(), y = personajePrincipal.position().y())
	}

	method direccion() {
		return personajePrincipal.direccion()
	}

	method nombre() = "sword"

	method teEncontro(personaje) {
	}

	method recibirAtaque() {
	}

	method recibirAtaque(danio) {
	}

	method mirarHacia() {
		return if (self.direccion() == left) {
			personajePrincipal.position().x() - 2
		} else {
			personajePrincipal.position().x()
		}
	}
	
}

object left {

	var property objetivos = #{}
	//var doubleTap = false
	
	method moveMC() { // Mov izquierda del MainCharacter (personaje principal)	
	// if(!doubleTap){ // Un pequeño retraso para no spamear botones de movilidad(y hacer más valioso el esquivar)			
		//game.schedule(1, { => doubleTap = true})
		runModeL.accion(personajePrincipal, personajePrincipal.direccion())
		//game.schedule(100, { => doubleTap = false})
	// }// Esta parte se podria reemplazar por una animacion continua de moverse pero no veo forma de hacerlo viable.
	}

	method move(objeto, num) { // general para cualquier objecto, pensado para usarse en los enemigos
	// objeto.actualizarPosicion(objeto.position().left(num)) // todos los objetos que se muevan deben entender el metodo "actualizarPosicion"
		objeto.position().x(objeto.position().x() - num)
	}

	method imagenPersonajeStand(objeto) {
		return objeto + "_Stand_left.png"
	}

	method imagenPersonajeAttack(objeto) { // probablemente los enemigos melee al igual que el MC tendran problemas al atacar del lado izquierdo
		return objeto + "_Attack_left.png"
	}
	method imagenPersonajeBlock(objeto){
		return objeto + "_Block_left.png"
	}
//	method atacarMC() {
//		if (not doubleTap and not personajePrincipal.blockStance()) {
//			game.schedule(1, { => doubleTap = true})
//			attackMode.accion(espadaMC, personajePrincipal.direccion())
//			game.schedule(1000, { => doubleTap = false})
//		}}
	
	method obtenerObjetosParaAtacar(objeto,distancia){
		var numero = distancia + 1
		var posicion 
		numero.times({iteracion => 		numero -= 1
										posicion = new Position(x = objeto.position().x() - numero, y = objeto.position().y())
										objetivos += game.getObjectsIn(posicion)
										})


	}
// si llega a haber problemas de rendimiento por atacar muy rapido lo mejor será hacer el ataque de la espada por separado
}

object right {

	//var doubleTap = false
	var property objetivos = #{}
	
	method moveMC() { // Mov derecha del MainCharacter (personaje principal)	
	// if(!doubleTap){ // Un pequeño retraso para no spamear botones de movilidad(y hacer más valioso el esquivar)	(desactivado por ahora mientras se resuelven bugs)		
	//	game.schedule(1, { => doubleTap = true})
		runModeR.accion(personajePrincipal, personajePrincipal.direccion())
	//	game.schedule(100, { => doubleTap = false})
	// }// Esta parte se podria reemplazar por una animacion continua de moverse pero no veo forma de hacerlo viable.
	}

	method move(objeto, num) { // general para cualquier objecto, pensado para usarse en los enemigos
		objeto.position().x(objeto.position().x() + num)
	// objeto.actualizarPosicion(objeto.position().right(num)) // todos los objetos que se muevan deben entender el metodo "actualizarPosicion"
	}

	method imagenPersonajeStand(objeto) {
		return objeto + "_Stand_right.png"
	}

	method imagenPersonajeAttack(objeto) { // probablemente los enemigos melee al igual que el MC tendran problemas al atacar del lado izquierdo
		return objeto + "_Attack_right.png"
	}
	method imagenPersonajeBlock(objeto){
		return objeto + "_Block_right.png"
	}
//	method atacarMC() {
//		if (not doubleTap and not personajePrincipal.blockStance()) {
//			game.schedule(1, { => doubleTap = true})
//			attackMode.accion(espadaMC, personajePrincipal.direccion())
//			game.schedule(1000, { => doubleTap = false})
//		}}
	
	method obtenerObjetosParaAtacar(objeto,distancia){
		var numero = distancia + 1 
		var posicion
		numero.times({iteracion => 		numero -= 1
										posicion = new Position(x = objeto.position().x() + numero, y = objeto.position().y())
										objetivos += game.getObjectsIn(posicion)
										})

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

