//
//  Shot.swift
//  WarFly
//
//  Created by Алексей Гуляев on 31.07.2024.
//

import SpriteKit

class Shot: SKSpriteNode {

	let screenSize = UIScreen.main.bounds
	fileprivate let initialSize = CGSize(width: 187, height: 237)
	fileprivate let textureAtlas: SKTextureAtlas!
	fileprivate var textureNameBeginWith = ""
	fileprivate var animationSpriteArray = [SKTexture]()

	init(textureAtlas: SKTextureAtlas) {
		self.textureAtlas = textureAtlas
		let textureName = textureAtlas.textureNames.sorted()[0]
		let currentTexture = textureAtlas.textureNamed(textureName)
		textureNameBeginWith = String(textureName.dropLast(6)) //01.png
		super.init(texture: currentTexture,
				   color: .clear,
				   size: initialSize)
		self.setScale(0.3)
		self.name = "shotSprite"
		self.zPosition = 30

		//зазадим физические саойства для выстрела
		self.physicsBody = SKPhysicsBody(
			texture: currentTexture,
			alphaThreshold: 0.5,
			size: self.size
		)

		//(более развернутое описание можно прочесть
		//в обноименных свойствах в классе PlayerPlane
		self.physicsBody?.isDynamic = false
		self.physicsBody?.categoryBitMask = BitMaskKategory.shot.rawValue
		self.physicsBody?.collisionBitMask = BitMaskKategory.enemy.rawValue
		self.physicsBody?.contactTestBitMask = BitMaskKategory.enemy.rawValue
	}

	func startMovement() {
		performRotation()
		//зададим движение
		let moveForward = SKAction.moveTo(y: screenSize.height + 100, duration: 2)
		//запустим его
		self.run(moveForward)
	}

	//реализуем создание анимации
	fileprivate func performRotation() {
		for i in 1...32 {
			//% значит что у нас сюда будет подставляться значение i,
			//если i будет с одним знаком то первым числом будет 0
			let number = String(format: "%02d", i)
			animationSpriteArray.append(SKTexture(imageNamed: textureNameBeginWith + number.description))
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

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
