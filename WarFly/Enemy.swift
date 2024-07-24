//
//  Enemy.swift
//  WarFly
//
//  Created by Алексей Гуляев on 23.07.2024.
//

import SpriteKit

class Enemy: SKSpriteNode {
	static var textureAtlas: SKTextureAtlas?

	init() {
		let textureEnemy = Enemy.textureAtlas?.textureNamed("airplane_4ver2_13")
		super.init(texture: textureEnemy, color: .clear, size: CGSize(width: 221, height: 204))
		self.xScale = 0.5
		self.yScale = -0.5
		self.zPosition = 20
		self.name = "sprite"
	}
	//Метод - позволяющий научить наших врагов летать по спирали
	func flyInSpiral() {
		let screenSize = UIScreen.main.bounds
		let timeHorizontal: Double = 3
		let timeVertical: Double = 10
		//Будет перемещаться по оси х не долетая 50 поинтов до края экрана
		let moveLeft = SKAction.moveTo(x: 50, duration: timeHorizontal)

		//для того что бы вражеский самолет не отскакивал так резко от краев экрана
		//добавим метод который будет делать - немного замедляться при приближении к границе экрана
		// и ускоряться при отскоке от края экрана
		moveLeft.timingMode = .easeInEaseOut

		let moveRight = SKAction.moveTo(x: screenSize.width - 50, duration: timeHorizontal)
		//Повторим тоже для движения в право
		moveRight.timingMode = .easeInEaseOut

		//Создадим последовательность движений в лево и право по оси х
		let enemyAsideMovementSequence = SKAction.sequence([moveLeft, moveRight])
		let enemyForeverAsideMovement = SKAction.repeatForever(enemyAsideMovementSequence)

		//Создадим последовательность движений по оси у
		let enemyForwardMovement = SKAction.moveTo(y: -105, duration: timeVertical)

		//Создадим движение по спирали - для этого обьединим движения по оси х и у
		let enemyGroupMovement = SKAction.group([enemyForeverAsideMovement, enemyForwardMovement])
		self.run(enemyGroupMovement)

	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
