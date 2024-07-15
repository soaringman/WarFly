//
//  PlayerPlane.swift
//  WarFly
//
//  Created by Алексей Гуляев on 08.07.2024.
//

import SpriteKit
import CoreMotion

class PlayerPlane: SKSpriteNode {

	let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

	//Создаем менеджера - для считывания показаний акселерометра
	let motionManager = CMMotionManager()
	var xAcceleration: CGFloat = 0

	//Создадим массив текстур для нашей анимации
	var leftTextureArrayAnimation = [SKTexture]()
	var rightTextureArrayAnimation = [SKTexture]()
	var forwardTextureArrayAnimation = [SKTexture]()

	//Определим переменные для поворотов
	var moveDirection: TurnDirection = .forward
	var stillTurning = false

	static func populate(at point: CGPoint) -> PlayerPlane {

		//Создаем текстуру. Текстура удобнее тем что она может изменяться в процессе а изображение - нет
		//и мы можем использовать покадровую анимацию с помощью SKTextureAtlas
		//И когда мы используем тукстуры для разных спрайтов то храниться всего одна копия тексутры
		
		let playerPlaneTexture = SKTexture(imageNamed: "airplane_3ver2_13.png")
		let playerPlane = PlayerPlane(texture: playerPlaneTexture)
		playerPlane.setScale(0.5)
		playerPlane.position = point
		playerPlane.zPosition = 20

		//Доп задание - можно с помощью диапазона задать - что бы какие то облака пролетали над самолетом,
		//а какие то под самолетом
		return playerPlane
	}

	// Метод - задающий поведение самолета по оси Х
	func checkXPosition() {

		//Определяем ускорение самолета
		self.position.x += xAcceleration * 50

		//Определение дествий для самолета, если ушло влево или в право больше чем на 70 поинтов
		if self.position.x < -70 {
			self.position.x = screenSize.width + 70
		} else if self.position.x > screenSize.width + 70 {
			self.position.x = -70
		}
	}

	//Метод - связывающий значение акселерометра с передвижением самолета по оси х и его ускорением
	func performFly() {
		//подгрузим сначала наши текстуры
		planeAimationFillArray()
		motionManager.accelerometerUpdateInterval = 0.2
		motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in

			if let data = data {
				let acceleration = data.acceleration
				self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
				print(self.xAcceleration)
			}
		}
	}

	//Метод - загружающий наши спрайты в соответствующие массивы
	fileprivate func planeAimationFillArray() {
		//Сначала мы должны подгрузить все наши текстуры на устройство (что бы не происходило микрофриза
		//во время первого запуска игры
		SKTextureAtlas.preloadTextureAtlases([SKTextureAtlas(named: "PlayerPlane")]) {
			
			//Поворот на лево
			self.leftTextureArrayAnimation = {
				var array = [SKTexture]()
				for i in stride(from: 13, through: 1, by: -1) {
					//пробежимся по нашим текстурам
					let number = String(format: "%02d", i)
					//теперь возьмем непосредственно текстуру
					let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
					//добавим ее в наш массив
					array.append(texture)
				}
				//добавим одну строку что бы не было тормозов
				SKTexture.preload(array, withCompletionHandler: {
						print("preload is done")
				})
				return array
			}()

			//Поворот на право
			self.rightTextureArrayAnimation = {
				var array = [SKTexture]()
				for i in stride(from: 13, through: 26, by: 1) {
					//пробежимся по нашим текстурам
					let number = String(format: "%02d", i)
					//теперь возьмем непосредственно текстуру
					let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
					//добавим ее в наш массив
					array.append(texture)
				}
				//добавим одну строку что бы не было тормозов
				SKTexture.preload(array, withCompletionHandler: {
					print("preload is done")
				})
				return array
			}()

			//Прямо
			self.forwardTextureArrayAnimation = {
				var array = [SKTexture]()
					//теперь возьмем непосредственно текстуру
					let texture = SKTexture(imageNamed: "airplane_3ver2_13")
					//добавим ее в наш массив
					array.append(texture)

				//добавим одну строку что бы не было тормозов
				SKTexture.preload(array, withCompletionHandler: {
					print("preload is done")
				})
				return array
			}()
		}
	}

	//Метод определяющий какую анимацию задействовать, так же проверяющий что если анимация уже происходит, то ее
	//не прерываем, и до того момента пока мы не полетим в одну сторону - анимацию проигрывтаь только 1 раз
	fileprivate func movementDirectionCheck() {
		if xAcceleration > 0.1, moveDirection != .onRight, stillTurning == false {
			//поворот на право
			stillTurning = true
			moveDirection = .onRight

		} else if xAcceleration < 0.1, moveDirection != .onLeft, stillTurning == false {
			//поворот на лево
		} else if stillTurning == false {
			//полет прямо
		}
	}

	//Метод - воспроизводящий анимацию поворота
	fileprivate func turnPlane(direction: TurnDirection) {
		var array = [SKTexture]()

		if direction == .onRight {
			array = rightTextureArrayAnimation
		} else if direction == .onLeft {
			array = leftTextureArrayAnimation
		} else {
			array = forwardTextureArrayAnimation
		}
		//теперь напишем несколько методов по анимации (прямая и обратная) для всех наших поворотов
		//время на видео 11:09
//		let forwardAction = SKAction.animate(with: [SKTexture], timePerFrame: <#T##TimeInterval#>, resize: <#T##Bool#>, restore: <#T##Bool#>)
	}
}

enum TurnDirection {
	case onLeft
	case onRight
	case forward
}
