//
//  GameScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 27.06.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

//	//Создаем менеджера - для считывания показаний акселерометра
//	let motionManager = CMMotionManager()
//	var xAcceleration: CGFloat = 0

	//создаем наш самолет (если его нет то приложение должно упасть)
	var player: PlayerPlane!



    override func didMove(to view: SKView) {

		configureStartScene()
		spawnClouds()
		spawnIsland()

		//поправим баг -  в начале игры у нас вместо текстуры самолета появляется белый квадрат
		//создаем переменную в которой говорим что мы хотим отсрочить запуск на 1 наносекунду
		let deadline = DispatchTime.now() + .nanoseconds(1)
		//отсрачиваем запуск нашего метода performFly
		DispatchQueue.main.asyncAfter(deadline: deadline) { [unowned self] in
			self.player.performFly()
		}

		spawnPowerUp()
		spawnEnemies()
    }

	fileprivate func spawnPowerUp() {
		//создали обьект типа PowerUP
		let powerUp = GreenPowerUp()
		//запустили анимацию
		powerUp.performRotation()
		powerUp.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
		//добавим ее на нашу сцену
		self.addChild(powerUp)
	}

	fileprivate func spawnEnemies() {
		let waitForAction = SKAction.wait(forDuration: 3.0)
		let spawnOfSpiralAction = SKAction.run { [unowned self] in
			self.spawnEnemiesOfSpiral()
		}
		//тройная вложенность и вариация на тему как можно быстро записать запуск последовательности бесконечно
		//В Боевом коде так делать не стоит, разве что для проверки работоспособности
		self.run(SKAction.repeatForever(SKAction.sequence([waitForAction, spawnOfSpiralAction])))

	}

	fileprivate func spawnEnemiesOfSpiral() {
		// Поработает со вражескими обьектами
		//СОздадим атлас текстур для нашего врага 1 и 2
		let enemyTextureAtlas1 = SKTextureAtlas(named: "Enemy_1")
		let enemyTextureAtlas2 = SKTextureAtlas(named: "Enemy_2")
		//сделавем предзагрузку атласа
		SKTextureAtlas.preloadTextureAtlases([enemyTextureAtlas1, enemyTextureAtlas2]) { [unowned self] in

			//напишем рандомазер который будет случайно выбирать либо первый атлас либо второй
			let randomnumber = Int(arc4random_uniform(2))
			//создадим массив атласов наших врагов (2 атласа)
			let arrayOfAtlases = [enemyTextureAtlas1, enemyTextureAtlas2]
			//теперь создадим переменную с номером атласа
			let textureEnemyAtlas = arrayOfAtlases[randomnumber]
			
			//сделаем задежку, что бы все наши враги не родились в одно и то же время
			let waitEnemyAction = SKAction.wait(forDuration: 1.0)
			let spawnEnemy = SKAction.run { [unowned self] in

				//Как выяснилось подзднее массив имен текстур а атласе приходит несоритрованный и поэтому мы не получаем
				//ту текстуру под номером 12, которую хотели испорльзовать, и мы отсортируем наш полученный массив имен текстур
				let sortedTextureNames = textureEnemyAtlas.textureNames.sorted()
				//Подготовим текстуру вражеского самолета
				let currentEnemyTexture = textureEnemyAtlas.textureNamed(sortedTextureNames[12])
				//Создаем вражеский самолет
				let enemy = Enemy(enemyTexture: currentEnemyTexture)
				//расположим его на экране
				enemy.position = CGPoint(x: self.size.width / 2, y: self.size.height + 110)
				//добавим его на наш экран
				self.addChild(enemy)
				enemy.flyInSpiral()
			}

			//После этого создадим последовательность задержки и нашей спирали из врагов
			let spawnEnemyAction = SKAction.sequence([waitEnemyAction, spawnEnemy])
			//повторим появление врага 3 раза
			let repeatEnemyAction = SKAction.repeat(spawnEnemyAction, count: 3)
			self.run(repeatEnemyAction)
		}
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

	}

	//Добавление метода в котором мы будем взаимедействовать с акселерометром нашего (физического устройства)
	//так как у симулятора датчика акселерометра нет
	override func didSimulatePhysics() {

		player.checkXPosition()

		//Метод - который проверяет, если позиция объекта по оси у меньше нуля то такой объект надо удалить со сцены
		enumerateChildNodes(withName: "sprite") { (node, stop) in
			//пришлось корректировать тут (поэтому условие -150 а не 0 как по логике должно быть
			if node.position.y < -100 {
				node.removeFromParent()
			}
		}
	}
}
