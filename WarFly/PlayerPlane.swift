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
		motionManager.accelerometerUpdateInterval = 0.2
		motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data, error) in

			if let data = data {
				let acceleration = data.acceleration
				self .xAcceleration = CGFloat(acceleration.x) * 0.7 + self.xAcceleration * 0.3
			}
		}
	}
}
