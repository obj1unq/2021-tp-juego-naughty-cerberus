import wollok.game.*
import clases.*
import enemigos.*
import misc.*
import menus.*

object personajePrincipal inherits ObjetosInteractuables{

	var property vida = 100
	var property energia = 100
	var property ataque = 100
	var property defensa = 20
	var property direccion = right
	var property position = new MiPosicion(x = 0, y = 1)
	var property nombre = "personaje"
	var property blockStance = false
	var property doubleTap = false
	var property tieneBala = false
	var property sigueEnAccion = false
	var image = direccion.imagenPersonajeStand(self.nombre())
	
	method image() = image

	method image(imagen) {
		image = imagen
	}

	method actualizarImagen() {
		self.image(direccion.imagenPersonajeStand(nombre.toString()))
	}

	method actualizarPosicion(nuevaPosicion) {
		position = nuevaPosicion
	}

//	method decirPos() {
//		self.error("PosX = " + self.position().x().toString() + ", PosY = " + self.position().y().toString())
//	}
	method standPositionImage(){
		if(!self.sigueEnAccion()){
			self.image(direccion.imagenPersonajeStand(self.nombre()))
		}
	}
	method moverse() {
		if (not self.blockStance()) {
			runModeMC.accion(self,self.direccion())
	//		direccion.moveMC()
		}
	}

	method bloquear() {
		self.verificarEnergia()
		energia -= 20
		self.modoBloqueo()
		game.schedule(500, { => self.salirDeModoBloqueo()})
	}

	method modoBloqueo() {
		if (not self.blockStance()) {
			blockStance = true
			defensa = 100
			self.image(direccion.imagenPersonajeBlock(self.nombre()))
		}
	}

	method salirDeModoBloqueo() {
		blockStance = false
		defensa = 20
		self.actualizarImagen()
	}

	method verificarEnergia() {
		if (energia < 20) {
			self.error("No tengo energia para bloquear")
		}
	}

	method recargarEnergia() {
		energia = (energia + 10).min(100)
	}

	method atacar() {
		if (not doubleTap and not self.blockStance()) {
			game.schedule(1, { => doubleTap = true})
			self.realizarAtaque()
			self.colisionarGolpe()
		}
	}

	method realizarAtaque() {
		attackMode.accion(espadaMC, self.direccion())
		game.schedule(500, { => doubleTap = false})
	}

	override method recibirAtaque(danio) {
		self.validarVida(danio)
		vida = vida - self.calculoDeDanio(danio)
		if (self.blockStance()) {
			game.sound("shieldBlock.mp3").play()
		}
	}

	method calculoDeDanio(danio) {
		return danio * (1 - self.defensa() / (100 + self.defensa()))
	}

	method validarVida(danio) {
		if (vida - self.calculoDeDanio(danio) <= 0) {
			self.morir()
		}
	}


	method morir() {
		game.removeVisual(self)
		game.removeVisual(espadaMC)
		endMenu.iniciar()
	}

	method colisionarGolpe() {
		direccion.obtenerObjetosParaAtacar(self, 2)
		direccion.objetivos().forEach{ objeto => objeto.recibirAtaque()}
		direccion.objetivos(#{})
	}

	method subirSiHayEscalera() {
		self.colisiones().forEach{ objeto => objeto.subir(self)}
//		self.verificarQueHayaEscalera()
//		self.irAlPisoDeArriba()
	}

	method bajarSiHayEscotilla() {
		self.colisiones().forEach{ objeto => objeto.bajar(self)}
//		self.verificarQueHayaEscotilla()
//		self.irAlPisoDeAbajo()
	}

//	method verificarQueHayaEscotilla() {
//		if (not self.colisiones().any({ objeto => objeto.esEscotilla()})) {
//			self.error("no hay escotilla para bajar")
//		}
//	}
//
//	method verificarQueHayaEscalera() {
//		if (not self.colisiones().any({ objeto => objeto.esEscalera()})) {
//			self.error("no hay escalera para subir")
//		}
//	}

	method colisiones() {
		return game.colliders(self)
	}

//	method escaleraPresente() {
//		return self.colisiones().find{ objeto => objeto.esEscalera() }
//	}
//
//	method escotillaPresente() {
//		return self.colisiones().find{ objeto => objeto.esEscotilla() }
//	}

	override method teEncontro(objeto) {
		objeto.encontrasteAlMC(self);
	}

	method caerSiNoEstasEnPiso() {
		if (not self.estaEnElPiso()) {
			self.position().y(self.position().y() - 1)
		}
	}

// agregado interactuar que con el/los objeto que colisiona le da la orden
	override method interactuar(){
		self.colisiones().forEach{ objeto => objeto.interactuar()}
	}


	method estaEnElPiso() {
		return self.position().y() == 1 or self.position().y() == 5
	}

//	method estaSobreUnCannon() {
//		return game.colliders(self).any{ objeto => objeto.esCannon() }
//	}
//
//	method estaSobreUnaCajaDeBalas() {
//		return game.colliders(self).contains(cajaDeBalas)
//	}

//	method agarrarBalaOCargarCannon() {
//		self.verificarQueEstaEnUnaCajaOUnCannon()
//		if (self.estaSobreUnaCajaDeBalas()) {
//			self.agarrarBalaSiNoTiene()
//		} else {
//			self.cargarCannonSiEstaDescargado()
//		}
//	}

	method agarrarBala(){
		self.tieneBala(true)
		game.say(self, "tengo una bala")
		self.nombre("personajeConBala")
		self.actualizarImagen()
	}
//	method verificarQueEstaEnUnaCajaOUnCannon() {
//		if (!self.estaSobreUnCannon() and !self.estaSobreUnaCajaDeBalas()) {
//			game.error("no estoy sobre un cañon o caja")
//		}
//	}
//
//	method agarrarBalaSiNoTiene() {
//		self.verificarQueNoTieneBala()
//		self.tieneBala(true)
//		game.say(self, "tengo una bala")
//		self.nombre("personajeConBala")
//		self.actualizarImagen()
//	}
//
//	method verificarQueNoTieneBala() {
//		if (self.tieneBala()) {
//			game.error("ya tengo una bala")
//		}
//	}

//	method cargarCannonSiEstaDescargado() {
//		self.verificarQueElCannonEstaDescargado()
//		self.verificarQueTengoBala()
//		self.cannonPresente().cargarSiTieneBala()
//		self.nombre("personaje")
//		self.actualizarImagen()
//	}

//	method verificarQueElCannonEstaDescargado() {
//		if (self.cannonPresente().estaCargado()) {
//			game.say(self, "este cañon ya esta cargado")
//			game.error("")
//		}
//	}


//	method verificarQueTengoBala() {
//		if (!self.tieneBala()) {
//			game.say(self, "no tengo bala para cargar")
//			game.error("")
//		}
//	}

//	method cannonPresente() {
//		return game.colliders(self).find{ objeto => objeto.esCannon() }
//	}
//	
//
//	method dispararCannon() {
//		self.verificarQueEstaEnUnCannon()
//		self.cannonPresente().disparar()
//	}
//
//	method verificarQueEstaEnUnCannon() {
//		if (!self.estaSobreUnCannon()) {
//			game.say(self, "no estoy sobre un cañon")
//			game.error("")
//		}
//	}

}

object espadaMC inherits ObjetosInteractuables{

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


//	method mirarHacia() {
//
//		return if (self.direccion() == left) {
//			personajePrincipal.position().x() - 2
//		} else {
//			personajePrincipal.position().x()
//		}
//	}
	method mirarHacia(){
		return self.direccion().mirarHacia(personajePrincipal)
	}

	method esEscalera() {
		return false
	}

	method esEscotilla() {
		return false
	}

}

object left {

	var property objetivos = #{}
	
// Con los cambios a los metodos de movimientos de los personajes, por ahora no es más necesario esto.
//	// var doubleTap = false
//	method moveMC() { // Mov izquierda del MainCharacter (personaje principal)	
//	// if(!doubleTap){ // Un pequeño retraso para no spamear botones de movilidad(y hacer más valioso el esquivar)			
//	// game.schedule(1, { => doubleTap = true})
//		runModeL.accion(personajePrincipal, personajePrincipal.direccion())
//	// }// Esta parte se podria reemplazar por una animacion continua de moverse pero no veo forma de hacerlo viable.
//	}
//
//	method moveWolf(lobo) {
//		runModeWolfL.accion(lobo, lobo.direccion())
//	}

	method darLaVuelta(objeto){
		objeto.direccion(right)
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

	method imagenPersonajeBlock(objeto) {
		return objeto + "_Block_left.png"
	}

	method obtenerObjetosParaAtacar(objeto, distancia) {
		var numero = distancia + 1
		var posicion
		numero.times({ iteracion =>
			numero -= 1
			posicion = new Position(x = objeto.position().x() - numero, y = objeto.position().y())
			objetivos += game.getObjectsIn(posicion)
		})
	}
	method mirarHacia(objeto){
		return objeto.position().x() - 2
	}

}

object right {

	// var doubleTap = false
	var property objetivos = #{}
// Con los cambios a los metodos de movimientos de los personajes, por ahora no es más necesario esto.
//	method moveMC() { // Mov derecha del MainCharacter (personaje principal)	
//	// if(!doubleTap){ // Un pequeño retraso para no spamear botones de movilidad(y hacer más valioso el esquivar)	(desactivado por ahora mientras se resuelven bugs)		
//	// game.schedule(1, { => doubleTap = true})
//		runModeR.accion(personajePrincipal, personajePrincipal.direccion())
//	// game.schedule(100, { => doubleTap = false})
//	// }// Esta parte se podria reemplazar por una animacion continua de moverse pero no veo forma de hacerlo viable.
//	}
//
//	method moveWolf(lobo) {
//		runModeWolfR.accion(lobo, lobo.direccion())
//	}
	method darLaVuelta(objeto){
		objeto.direccion(left)
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

	method imagenPersonajeBlock(objeto) {
		return objeto + "_Block_right.png"
	}

	method obtenerObjetosParaAtacar(objeto, distancia) {
		var numero = distancia + 1
		var posicion
		numero.times({ iteracion =>
			numero -= 1
			posicion = new Position(x = objeto.position().x() + numero, y = objeto.position().y())
			objetivos += game.getObjectsIn(posicion)
		})
	}
	method mirarHacia(objeto){
		return objeto.position().x()
	}
}

object up {

	method moveDragon(_dragon) {
		runModeDragonU.accion(_dragon, _dragon.direccion())
	}

	method move(objeto, num) { // general para cualquier objecto, pensado para usarse en los enemigos
		objeto.position().y(objeto.position().y() + num)
	}

	method imagenPersonajeStand(objeto) {
		return objeto + "_Stand_up.png"
	}
	method darLaVuelta(objeto){
		objeto.direccion(down)
	}

}

object down {

	method moveDragon(_dragon) {
		runModeDragonD.accion(_dragon, _dragon.direccion())
	}

	method move(objeto, num) { // general para cualquier objecto, pensado para usarse en los enemigos
		objeto.position().y(objeto.position().y() - num)
	}

	method imagenPersonajeStand(objeto) {
		return objeto + "_Stand_up.png"
	}
	method darLaVuelta(objeto){
		objeto.direccion(up)
	}

}

object wulgrym inherits ObjetosInteractuables{ //En un futuro,de continuarse el juego,el seria nuestro mercader

	var property position = new MiPosicion(x = 3, y = 1)
	var intentos = 1

	method image() {
		return "wulgrym.png"
	}

	override method teEncontro(objeto) {
		if (intentos == 1) {
			game.addVisual(wulgrymDialog)
			self.configurarDialogo()
			intentos -= 1
		}
	}

	method configurarDialogo() {
		keyboard.enter().onPressDo({ wulgrymDialog.siguienteDialogo()})
	}

}

object wulgrymDialog inherits ObjetosInteractuables{

	var numeroDialogo = 1
	var property position = new MiPosicion(x = 0, y = 0)

	method image() {
		return "wulgrym_dialog_" + numeroDialogo.toString() + ".png"
	}

	method siguienteDialogo() {
		numeroDialogo = (numeroDialogo + 1).min(4)
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

