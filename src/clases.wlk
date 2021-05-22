import personaje.*

class Mode {
	var property accion // nombre de la accion a realizar
	var property speedFrame	// la velocidad de animacion de los frames
	var property totalImg	// la cantidad total de imagenes(cantidad de frames)
	var property time		// el comienzo del conteo de cantidad de img
}
const AttackMode = new Mode(accion = "Attack", speedFrame = 65, totalImg = 3, time=0)	

const RunMode = new Mode(accion = "Run", speedFrame = 60, totalImg = 3, time=0)

const DieMode = new Mode(accion = "Die", speedFrame = 60, totalImg = 3, time=0)