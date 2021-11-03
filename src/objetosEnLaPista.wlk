import wollok.game.*
import autos.*
import puntaje.*
import Fondo.*
import juegoYConfiguraciones.*


class ElementoMovil{
	var property position 
	
	method caer(){
		position = self.position().down(1)
	}
	
}

class ObjetoEnLaPista inherits ElementoMovil{
	var imagen 
	var valorXDesaparecer 
	
	const todosLosEnemigos = [] 
	const property bloques =[]
	method soyPlayer() = false
	method image() = imagen
	
	override method caer(){
		super()
		self.desaparece()
		bloques.forEach({bloque=>bloque.position(bloque.position().down(1))})
	}
	
	method desaparece(){
		if(self.position().y() <= -3 or self.position().y() >= game.height()-5){
			self.removerObjeto()
			puntaje.sumarPuntos(valorXDesaparecer)
			
		}
	}
	
	method removerObjeto(){
		game.removeVisual(self)
		todosLosEnemigos.remove(self)
		bloques.forEach({bloque=>game.removeVisual(bloque)})
	}
	
	method choqueConTanque(){
		self.removerObjeto()
	}
	
	method choqueConPlayer(){
		self.removerObjeto()	
	}	
}

class ManchaAceite inherits ObjetoEnLaPista(imagen = "aceite.png", valorXDesaparecer = 0){	
//	override method chocarCon(unAuto){
//		 
//	}
	
	override method choqueConPlayer(){
		self.desplazamientoAleatorio(auto)
	}
	
	method desplazamientoAleatorio(unAuto){
		const desplazamiento = 1.randomUpTo(10).truncate(0)
		if(desplazamiento.even()){
			unAuto.horizontal(3)
		}
		else{
			unAuto.horizontal(-3)
		}
		
	}
}

class Reparador inherits ObjetoEnLaPista(imagen = "llave.png", valorXDesaparecer = 0){
	override method choqueConPlayer(){
		if (vida.cantidad() < 4){			
			vida.cantidad(4)
			super()
		}
	}	
}

class BalaDeTanque inherits ObjetoEnLaPista(imagen = "balaTanque.png", valorXDesaparecer = 0){
	override method choqueConPlayer(){
		vida.cantidad(vida.cantidad()-2)
		super()
	}
	override method choqueConTanque(){}
	
	}
class BalaDePlayer inherits ObjetoEnLaPista(imagen = "balaTanque.png", valorXDesaparecer = 0){
	override method choqueConTanque(){
		tanque.vida(tanque.vida()-1)
		super()
	}
	override method caer(){
		position = self.position().up(1)
		bloques.forEach({bloque=>bloque.position(bloque.position().up(1))})
		self.desaparece() 
		if(!game.hasVisual(self)){
			auto.cancelarDisparo(auto.cancelarDisparo()+1)
		}
		
	}
	override method choqueConPlayer(){
	}
	
}

class BloqueInvisible{
	var property position
	const duenio
	method soyPlayer() = false
	method image() = "pixel.png"
	
	method chocarCon(algo){
		//duenio.chocarCon(algo)
		algo.choqueConPlayer()
	}
	
	method choqueConPlayer(){
		duenio.choqueConPlayer()	
	}
	method choqueConTanque(){
		duenio.choqueConTanque()	
	}
}
