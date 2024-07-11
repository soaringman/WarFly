//
//  GameScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 27.06.2024.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene {

	//Создаем менеджера - для считывания показаний акселерометра
	let motionManager = CMMotionManager()
	var xAcceleration: CGFloat = 0

	//создаем наш самолет (если его нет то приложение должно упасть)
	var player: SKSpriteNode!



    override func didMove(to view: SKView) {

		configureStartScene()
		spawnClouds()
		spawnIsland()
    }
	//Метод - генерирующий облака и интервалы (попробовать сделать реализацию через протокол)!!!
	fileprivate func spawnClouds() {
		//первый метод (эшкн) будет задавать интервал в течении которого ничего происходить не будет
		let spawnCloudWait = SKAction.wait(forDuration: 1)

		//второй метод (экшн) будет генерировать острова и облака
		let spawnCloudAction = SKAction.run {
			let cloud = Cloud.populate(at: nil)
			self.addChild(cloud)
		}

		//Теперь создаем беспонечную последоватьность куда будем генерировать наши обьекты
		let spawnCloudSequence = SKAction.sequence([spawnCloudWait, spawnCloudAction])
		let spawnCloudForever = SKAction.repeatForever(spawnCloudSequence)
		run(spawnCloudForever)
	}

	//Метод - генерирующий острова и интервалы (попробовать сделать реализацию через протокол)!!!
	fileprivate func spawnIsland() {
		//первый метод (эшкн) будет задавать интервал в течении которого ничего происходить не будет
		let spawnIslandWait = SKAction.wait(forDuration: 2)

		//второй метод (экшн) будет генерировать острова и облака
		let spawnIslandAction = SKAction.run {
			let island = Island.populate(at: nil)
			self.addChild(island)
		}

		//Теперь создаем беспонечную последоватьность куда будем генерировать наши обьекты
		let spawnIslandSequence = SKAction.sequence([spawnIslandWait, spawnIslandAction])
		let spawnIslandForever = SKAction.repeatForever(spawnIslandSequence)
		run(spawnIslandForever)
	}

	fileprivate func configureStartScene() {

		//конфигурирование подложки
		let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
		let background = Background.populateBackground(at: screenCenterPoint)
		background.size = self.size
		self.addChild(background)

		//вычисляем расположение 5-ти островов (создаются рандомные коорднаты островов в пределах экрана)
		//Возможно дописать проверку на то, что бы острова не пересекались
		let screen = UIScreen.main.bounds

		//предварительно создадим два острова, задав их положение хардкодом
		let island1 = Island.populate(at: CGPoint(x: 100, y: 200))
		self.addChild(island1)

		let island2 = Island.populate(at: CGPoint(x: self.size.width - 100, y: self.size.height - 200))
		self.addChild(island2)

		player = PlayerPlane.populate(at: CGPoint(x: screen.size.width / 2, y: 100))
		self.addChild(player)

		motionManager.accelerometerUpdateInterval = 0.2
		motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in

			if let data = data {
				let acceleration = data.acceleration
				self .xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
			}
		}
	}

	//Добавление метода в котором мы будем взаимедействовать с акселерометром нашего (физического устройства)
	//так как у симулятора датчика акселерометра нет
	override func didSimulatePhysics() {
		super.didSimulatePhysics()

		//Определяем логику поведения самолета по иси х
		player.position.x += xAcceleration * 50

		//Определение дествий если ушло влево или в право больше чем на 70 поинтов
		if player.position.x < -70 {
			player.position.x = self.size.width + 70
		} else if player.position.x > self.size.width + 70 {
			player.position.x = -70
		}

		//Метод - который проверяет, если позиция объекта по оси у меньше нуля то такой объект надо удалить со сцены
		enumerateChildNodes(withName: "backgroundSprite") { (node, stop) in
			if node.position.y < -150 {
				node.removeFromParent()
			}
		}
	}
}
