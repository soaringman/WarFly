//
//  GameScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 27.06.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

	//создадим наш единсвенный экземпляр SceneManager
	let sceneManager = SceneManager.shared

	//создаем наш самолет (если его нет то приложение должно упасть)
	fileprivate var player: PlayerPlane!

	//создадим реализацию нашего класса интерфейса
	fileprivate let hud = HUD()
	fileprivate let currentScreenSize = UIScreen.main.bounds.size



    override func didMove(to view: SKView) {
		
		//когда мы обратно возвращаемся на нашу сцену мы должны
		//снять с паузы нашу игру
		self.scene?.isPaused = false


		//напишем проверку: если gameScene равна нил, то мы просто выходим из метода didMove, если равно нил
		//то инициализируем все методы которые подготавливают обьекты нашей игры
		guard sceneManager.gameScene == nil else { return }

		//сохраним нашу сцену в наш SceneManager
		sceneManager.gameScene = self


		//пропишем физические свойства и здесь
		//пропишем делегата но для этого нужно наш класс
		//GameScene подписать под отот протокол
		physicsWorld.contactDelegate = self

		//гравитацию
		physicsWorld.gravity = CGVector.zero

		configureStartScene()
		spawnClouds()
		spawnIsland()
		self.player.performFly()
		spawnPowerUp()
		spawnEnemies()
		CreateHUD()
    }

	fileprivate func CreateHUD() {
		//добавим интерфейс на экран
		addChild(hud)
		hud.configureUI(screenSize: currentScreenSize)
	}

	fileprivate func spawnPowerUp() {

		//создадим экшн через замыкание
		let spawnAction = SKAction.run {
			//смоздадим рандомизатор на 2 значения (0 и 1)
			let rundomNumber = Int(arc4random_uniform(2))
			//напишем через тернарный оператор условие - если случайное число равно 0 то выбираем BluePOwerUp а иначе
			//1 и GreenPowerUp
			let powerUp = rundomNumber == 1 ? BluePowerUp() : GreenPowerUp()
			//теперь определим еще одно рандоное число для нашего powerUp по оси х
			let randomPositionX = arc4random_uniform(UInt32(self.size.width - 30))
			//теперь используя позицию по оси х зададим расположение нашего powerUp
			powerUp.position = CGPoint(x: CGFloat(randomPositionX), y: self.size.height + 100)
			//теперь запустим наш экшн
			powerUp.startMovement()
			//добавим ее на нашу сцену
			self.addChild(powerUp)
		}
		
		//напишем райдомайзер для спавна наших powerUp
		let randomTimeSpawn = Double(arc4random_uniform(11) + 10)
		let waitAction = SKAction.wait(forDuration: randomTimeSpawn)

		self.run(SKAction.repeatForever(SKAction.sequence([spawnAction, waitAction])))
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
		let enemyTextureAtlas1 = Assets.shared.enemy_1Altas
		let enemyTextureAtlas2 = Assets.shared.enemy_2Altas
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
			if node.position.y <= -100 {
				node.removeFromParent()
			}
		}
		//сделаем проверку в обратную сторону и удаление спрайтов наших выстрелов которые улетят за экран (у = + 100)
		enumerateChildNodes(withName: "shotSprite") { (node, stop) in
			//я хочу что бы если вылел за вернюю гриницу экрана + 100, он бы удалялся
			if node.position.y >= self.size.height + 100 {
				node.removeFromParent()
			}
		}
	}

	//Напишем новый метод, который будет создавать наш выстрел
	fileprivate func playerFire() {
		//создадим наш выстрел типа YellowShot
		let shot = YellowShot()
		shot.position = self.player.position
		shot.startMovement()
		self.addChild(shot)
	}

	//используем метод  TouchesBegan - который нам позволит делать что то когда будет зафиксировано прикосновение к
	//экрану

	//ловим действие
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		//ловим первое касание на текущем экране (место на которое мы нажали)
		let location = touches.first!.location(in: self)
		
		//метод addPoint позволяет получить обьект под той областью на которую мы нажали
		//(предположительно наша кнопка)
		let node = self.atPoint(location)
		
		//теперь проверяем что под этой областью надодиться нода "pause"
		if node.name == "pause" {

			//напишем метод поауза который умеет фиксировать все элемены
			//(т.е. запирает все, так же можно сделать так что будет ставиться на паузу только определенная группа элементов)


			//то осуществить переход на другую сцену crossFade (один из вариантов перехода)
			let transition = SKTransition.doorway(withDuration: 1.0)

			//теперь создадим ту цену на которую хотим перейти с размерами нашей текущей сцены
			let pauseScene = PauseScene(size: self.size)

			//масштаб сцены
			pauseScene.scaleMode = .aspectFill

			//сохраним нашу игровую сцену в sceneManager
			sceneManager.gameScene = self


			//поставим на паузу всю текущую сцену (когда мы ставим на паузу то, все что внутри сцены:
			//все наши обьекты - ноды внутри сцены и все экшены этих обьектов тоже ставляться на паузу)
			self.scene?.isPaused = true

//			остановился на уроке 34 время 3:40

			//осуществим сам переход с тем видом (transition) который мы ранее выбрали
			self.scene!.view?.presentScene(pauseScene, transition: transition)
		} else {
			playerFire()
		}
	}
}

extension GameScene: SKPhysicsContactDelegate {

	func didBegin(_ contact: SKPhysicsContact) {
		let contactCategory: BitMaskKategory = [contact.bodyA.category, contact.bodyB.category]
		switch contactCategory {
		case [.player, .enemy]: print("enemy vs player")
		case [.player, .powerUp]: print("powerUp vs player")
		case [.shot, .enemy]: print("shot vs enemy")
		default: preconditionFailure("Невозможно поределить категорию столкновения")
		}
	}

	func didEnd(_ contact: SKPhysicsContact) {

	}
}
