//
//  PowerUp.swift
//  WarFly
//
//  Created by Алексей Гуляев on 18.07.2024.
//

import UIKit
import SpriteKit

class PowerUp: SKSpriteNode {

	let initialSize = CGSize(width: 52, height: 52)
	let textureAtlas = SKTextureAtlas(named: "GreenPowerUp")
	var animationSpriteArray = [SKTexture]()

	init() {
		let greenTexture = textureAtlas.textureNamed("missle_green_01")
		super.init(texture: greenTexture,
					 color: .clear,
					 size: initialSize)
		self.name = "sprite"
		self.zPosition = 20
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	//реализуем создание анимации
	func performRotation() {
		for i in 1...15 {
			//% значит что у нас сюда будет подставляться значение i,
			//если i будет с одним знаком то первым числом будет 0
			let number = String(format: "%02d", i)
			animationSpriteArray.append(SKTexture(imageNamed: "missle_green_\(number)"))
		}

		//Предварительно подгрузим наши текстуры (что было тормозов при первом запуске)
		SKTexture.preload(animationSpriteArray) {
			//комплишн хендлер используетися для того что бы мы сделали что то после того как наш массив загрузиться
			//сделаем анимацию тем же методом, которым делали ранее
			let rotation = SKAction.animate(with:
												self.animationSpriteArray,
												timePerFrame: 0.09,
												resize: true,
												restore: false
			)
			let rotationForever = SKAction.repeatForever(rotation)
			self.run(rotationForever)
		}
	}
}
