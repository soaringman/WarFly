//
//  Enemy.swift
//  WarFly
//
//  Created by Алексей Гуляев on 23.07.2024.
//

import SpriteKit

class Enemy: SKSpriteNode {
	static var textureAtlas: SKTextureAtlas?
	var enemyTexture: SKTexture!

	init(enemyTexture: SKTexture) {
		let texture = enemyTexture
		super.init(texture: texture, color: .clear, size: CGSize(width: 221, height: 204))
		self.xScale = 0.5
		self.yScale = -0.5
		self.zPosition = 20
		self.name = "sprite"

		//зазадим физические саойства для врага
		self.physicsBody = SKPhysicsBody(
			texture: texture,
			alphaThreshold: 0.5,
			size: self.size
		)

		//(более развернутое описание можно прочесть
		//в обноименных свойствах в классе PlayerPlane
		self.physicsBody?.isDynamic = true
		self.physicsBody?.categoryBitMask = BitMaskKategory.enemy
		self.physicsBody?.collisionBitMask = BitMaskKategory.player | BitMaskKategory.shot
		self.physicsBody?.contactTestBitMask = BitMaskKategory.player | BitMaskKategory.shot
	}
	//Метод - позволяющий научить наших врагов летать по спирали
	func flyInSpiral() {
		let screenSize = UIScreen.main.bounds
		let timeHorizontal: Double = 3
		let timeVertical: Double = 5
		//Будет перемещаться по оси х не долетая 50 поинтов до края экрана
		let moveLeft = SKAction.moveTo(x: 50, duration: timeHorizontal)

		//для того что бы вражеский самолет не отскакивал так резко от краев экрана
		//добавим метод который будет делать - немного замедляться при приближении к границе экрана
		// и ускоряться при отскоке от края экрана
		moveLeft.timingMode = .easeInEaseOut

		let moveRight = SKAction.moveTo(x: screenSize.width - 50, duration: timeHorizontal)
		//Повторим тоже для движения в право
		moveRight.timingMode = .easeInEaseOut

		//напишем метод для случайного выбора стороны полета по оси х - значение будет либо 0 либо 1
		let randomFlyingSide = Int(arc4random_uniform(2))

		//Создадим последовательность движений в лево и право по оси х
		//напишем условие с помощью тернарного оператора
		//(если случайное значение равно 0 то равно "в лево" и последовательность сначало в лево а потом в право
		//либо если не равно то наоборот
		let enemyAsideMovementSequence = randomFlyingSide == EnemyDirection.left.rawValue ?
		SKAction.sequence([moveLeft, moveRight]) : SKAction.sequence([moveRight, moveLeft])

		let enemyForeverAsideMovement = SKAction.repeatForever(enemyAsideMovementSequence)

		//Создадим создадим движение по оси у
		let enemyForwardMovement = SKAction.moveTo(y: -105, duration: timeVertical)

		//Создадим движение по спирали - для этого обьединим движения по оси х и у
		let enemyGroupMovement = SKAction.group([enemyForeverAsideMovement, enemyForwardMovement])
		self.run(enemyGroupMovement)

	}
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

enum EnemyDirection: Int {
	case left = 0
	//для второго кейса я могу не присваивать значение явно так как я указал что значения Int и указал
	//значение первого кейса
	case right
}
