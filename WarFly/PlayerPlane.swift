//
//  PlayerPlane.swift
//  WarFly
//
//  Created by Алексей Гуляев on 08.07.2024.
//

import SpriteKit

class PlayerPlane: SKSpriteNode {
	static func populate(at point: CGPoint) -> SKSpriteNode {

		//Создаем текстуру. Текстура удобнее тем что она может изменяться в процессе а изображение - нет
		//и мы можем использовать покадровую анимацию с помощью SKTextureAtlas
		//И когда мы используем тукстуры для разных спрайтов то храниться всего одна копия тексутры
		
		let playerPlaneTexture = SKTexture(imageNamed: "airplane_3ver2_13.png")
		let playerPlane = SKSpriteNode(texture: playerPlaneTexture)
		playerPlane.setScale(0.5)
		playerPlane.position = point
		playerPlane.zPosition = 20

		//Доп задание - можно с помощью диапазона задать - что бы какие то облака пролетали над самолетом,
		//а какие то под самолетом
		return playerPlane
	}

}
