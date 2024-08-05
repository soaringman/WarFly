//
//  PlayerPlane.swift
//  WarFly
//
//  Created by Алексей Гуляев on 08.07.2024.
//

import SpriteKit
import CoreMotion


class PlayerPlane: SKSpriteNode {

	//нужно для того что бы мы могли отталкиваться от размеров экрана
	let screenSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

	//Создаем менеджера - для считывания показаний акселерометра (отслежавания наших поворотов)
	let motionManager = CMMotionManager()
	// для трасформации значения аксерелометра в скорость полета по оси х
	var xAcceleration: CGFloat = 0

	//Создадим массив текстур для нашей анимации
	var leftTextureArrayAnimation = [SKTexture]()
	var rightTextureArrayAnimation = [SKTexture]()
	var forwardTextureArrayAnimation = [SKTexture]()

	//Определим переменные для поворотов
	//для определения направления в котором мы летим (лево или право)
	var moveDirection: TurnDirection = .forward
	//флаг для понимания, была ли выполнена анимация поворота
	//что бы в дальнейшем использовать его в методе который выполняет анимцию 1 раз если мы не меняем направления
	var stillTurning = false
	//Создадим кортеж с нашими значениями для перебора спрайтов
	let animationsSpriteStrides = [(13, 1, -1), (13, 26, 1), (13, 13, 1)]

	//метод - для создания нашего самолета
	static func populate(at point: CGPoint) -> PlayerPlane {

		//Создаем текстуру. Текстура удобнее тем что она может изменяться в процессе а изображение - нет
		//и мы можем использовать покадровую анимацию с помощью SKTextureAtlas
		//И когда мы используем тукстуры для разных спрайтов то храниться всего одна копия тексутры
		
		let currentAtlas = Assets.shared.playerPlaneAltas
		let playerPlaneTexture = currentAtlas.textureNamed("airplane_3ver2_13.png")
		let playerPlane = PlayerPlane(texture: playerPlaneTexture)
		playerPlane.setScale(0.5)
		playerPlane.position = point
		playerPlane.zPosition = 40

		//Доп задание - можно с помощью диапазона задать - что бы какие то облака пролетали над самолетом,
		//а какие то под самолетом

		//создадим физическое тело (это совй ство позволит нашим обьектам сталкиваться)
		
		/*
		 
		 создание физического тела путем добалвения пути посредством ключевых точек
		//Это координаты нашей артинки по х и у
		let offsetX = playerPlane.frame.size.width * playerPlane.anchorPoint.x;
		let offsetY = playerPlane.frame.size.height * playerPlane.anchorPoint.y;

		//Дальше нужен путь по которому мы будем отрисовывать нашу картинку

		//создаем path
		let path = CGMutablePath()

		//дальше передвигаемся в первую точку нашей фигуры
		path.move(to: CGPoint(x: 47 - offsetX, y: 47 - offsetX))

		// добавляем все наши линии
		path.addLine(to: CGPoint(x: 64 - offsetX, y: 85 - offsetY))
		path.addLine(to: CGPoint(x: 72 - offsetX, y: 99 - offsetY))
		path.addLine(to: CGPoint(x: 78 - offsetX, y: 98 - offsetY))
		path.addLine(to: CGPoint(x: 84 - offsetX, y: 84 - offsetY))
		path.addLine(to: CGPoint(x: 141 - offsetX, y: 75 - offsetY))
		path.addLine(to: CGPoint(x: 141 - offsetX, y: 66 - offsetY))
		path.addLine(to: CGPoint(x: 85 - offsetX, y: 57 - offsetY))
		path.addLine(to: CGPoint(x: 77 - offsetX, y: 24 - offsetY))
		path.addLine(to: CGPoint(x: 94 - offsetX, y: 19 - offsetY))
		path.addLine(to: CGPoint(x: 94 - offsetX, y: 10 - offsetY))
		path.addLine(to: CGPoint(x: 79 - offsetX, y: 8 - offsetY))
		path.addLine(to: CGPoint(x: 75 - offsetX, y: 6 - offsetY))
		path.addLine(to: CGPoint(x: 72 - offsetX, y: 7 - offsetY))
		path.addLine(to: CGPoint(x: 56 - offsetX, y: 10 - offsetY))
		path.addLine(to: CGPoint(x: 56 - offsetX, y: 19 - offsetY))
		path.addLine(to: CGPoint(x: 69 - offsetX, y: 23 - offsetY))
		path.addLine(to: CGPoint(x: 67 - offsetX, y: 56 - offsetY))
		path.addLine(to: CGPoint(x: 8 - offsetX, y: 66 - offsetY))
		path.addLine(to: CGPoint(x: 8 - offsetX, y: 76 - offsetY))

		//теперь нужно закрыть нашу траэкторию
		path.closeSubpath()

		//теперь присвоим нашему физическому телу созданную выше траэкторию
		playerPlane.physicsBody = SKPhysicsBody(polygonFrom: path)
		
		*/

		//сюда мы присвоим битовую маску

		playerPlane.physicsBody = SKPhysicsBody(
			texture: playerPlaneTexture,
			alphaThreshold: 0.5,
			size: playerPlane.size
		)

		//добавим допольнительные физические параметры
		
		//дополнительно про свойста, которые можно добавить нашим обектам,
		//что бы добавить им реалистичности можно почитать в документации
		//про "physicsBody"

		//параметр dynamic говорит о том что наш обект при попадении в него каких
		//либо других обьектов не будет двигатся (как бы будет стеной)
		playerPlane.physicsBody?.isDynamic = false
		//так же зададим битовую маску нашему самолету
		playerPlane.physicsBody?.categoryBitMask = BitMaskKategory.player
		//теперь укажем битовые маски обьектов с которыми мы можем сталкиваться
		playerPlane.physicsBody?.collisionBitMask = BitMaskKategory.enemy | BitMaskKategory.powerUp
		//теперь пропишем какие столновения нам нужно будет регистрировать
		playerPlane.physicsBody?.contactTestBitMask = BitMaskKategory.enemy | BitMaskKategory.powerUp

		return playerPlane

		/* ДОПОЛНИТЕЛЬНЫЙ МАТЕРИАЛ
		Как отрисовать физическое тело определенной формы:
		 Соотвествующий материал добавил в Обсидиан за 05/07/2024
		*/

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
		preloadTextureArrays()
		motionManager.accelerometerUpdateInterval = 0.2
		//так же что бы не было цикла сильных ссылок прописываем что мы не ссылаемся по жесткой ссылке на наш
		//лист захвата пропишем [unowned self]
		motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { [unowned self] (data, error) in

			if let data = data {
				let acceleration = data.acceleration
				self.xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
			}
		}

		// так как мы ходим запускать проверку периодически с разницей в 1 секунду то
		let planeWaitAction = SKAction.wait(forDuration: 1.0)
		//так же что бы не было цикла сильных ссылок прописываем что мы не ссылаемся по жесткой ссылке на наш
		//лист захвата пропишем [unowned self]
		let planeDirectionCheckAction = SKAction.run { [unowned self] in
			self.movementDirectionCheck()
		}
		//напишем непрерывный запуск наших методов
		let planeSequence = SKAction.sequence([planeWaitAction, planeDirectionCheckAction])
		let planeSequnceForever = SKAction.repeatForever(planeSequence)
		self.run(planeSequnceForever)
	}

	fileprivate func preloadTextureArrays() {
		for i in 0...2 {
			self.preloadArray(_stride: animationsSpriteStrides[i], callback: { [unowned self] array in
				switch i {
				case 0: self.leftTextureArrayAnimation = array
				case 1: self.rightTextureArrayAnimation = array
				case 2: self.forwardTextureArrayAnimation = array
				default: break
				}
			})
		}
	}

	//Напишем метод котрый принимает кортеж и подготавливает замыкание или (колбэк)
	fileprivate func preloadArray(_stride: (Int, Int, Int), callback: @escaping (_ array: [SKTexture]) -> Void) {
			var array = [SKTexture]()
		for i in stride(from: _stride.0, through: _stride.1, by: _stride.2) {
			//пробежимся по нашим текстурам
			let number = String(format: "%02d", i)
			//теперь возьмем непосредственно текстуру
			let texture = SKTexture(imageNamed: "airplane_3ver2_\(number)")
			//добавим ее в наш массив
			array.append(texture)
		}
		//вернем полученный массив в наш callback для последующего использования
		SKTexture.preload(array) {
			callback(array)
		}
	}

	//Метод определяющий какую анимацию задействовать, так же проверяющий что если анимация уже происходит, то ее
	//не прерываем, и до того момента пока мы не полетим в другую сторону - анимацию проигрывать только 1 раз
	fileprivate func movementDirectionCheck() {
		if xAcceleration > 0.02, moveDirection != .onRight, stillTurning == false {
			//поворот на право
			stillTurning = true
			moveDirection = .onRight
			turnPlane(direction: .onRight)

		} else if xAcceleration < -0.02, moveDirection != .onLeft, stillTurning == false {
			//поворот на лево
			stillTurning = true
			moveDirection = .onLeft
			turnPlane(direction: .onLeft)

		} else if stillTurning == false {
			//полет прямо
			turnPlane(direction: .forward)
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
		//сделаем прямую анимацию из массива array, со временем 0.05б с изменением текстуры в масштабе,
		//не возвращатся к первому кадру анимации
		let forwardAction = SKAction.animate(with: array, timePerFrame: 0.035, resize: true, restore: false)
		//теперь проведем обратную анимацию
		let backwardAction = SKAction.animate(with: array.reversed(), timePerFrame: 0.035, resize: true, restore: false)
		//так как полная анимация у нас представляет из себя последовательность (прямая + обратная) то
		let sequenceAction = SKAction.sequence([forwardAction, backwardAction])
		//тперь запустим анимацию
		//так же что бы не было цикла сильных ссылок прописываем что мы не ссылаемся по жесткой ссылке на наш 
		//лист захвата пропишем [unowned self]
		self.run(sequenceAction) { [unowned self] in
			self.stillTurning = false
		}
	}
}

enum TurnDirection {
	case onLeft
	case onRight
	case forward
}
