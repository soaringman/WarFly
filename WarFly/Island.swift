//
//  Island.swift
//  WarFly
//
//  Created by Алексей Гуляев on 03.07.2024.
//

import SpriteKit
import GameplayKit

final class Island: SKSpriteNode, IGameBackgroundSpritable {

	//используя этот метод у нас отсрова плывут в одну точку
	static func populate(at point: CGPoint?) -> Island {
		let islandImageName = configureName()
		let island = Island(imageNamed: islandImageName)

		//конфигурируем остров
		island.setScale(randomScaleFactor)
		island.position = point ?? randomPoint()
		island.zPosition = 1
		island.name = "sprite"
		//тем самым мы сместим значение координаты y нашей точки - point с центра на верхнюю гриницу
		//но как выяснилось это почему то не сработало для каких то пределенных обьектов
		//(у них не определился или некорректно определился anchorPoint)
		island.anchorPoint = CGPoint(x: 0.5, y: 1.0)
		island.run(rotateForRandomAngle())
		island.run(move(from: island.position))

		return island
	}

//	//используя этот метод острова будут плыть нормально (с верху вниз)
//		static func populate(at point: CGPoint) -> Island {
//			let islandImageName = configureName()
//			let island = Island(imageNamed: islandImageName)
//
//			//конфигурируем остров
//			island.setScale(randomScaleFactor)
//			island.position = point
//			island.zPosition = 1
//			island.run(rotateForRandomAngle())
//			island.run(move(from: island.position))
//
//			return island
//	}
	//Метод - рандомное измение островов (имени выводимого острова)
	fileprivate static func configureName() -> String {
		let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
		let randomNumber = distribution.nextInt()
		let imageName = "is" + "\(randomNumber)"

		return imageName
	}
	// Метод - Рандомное изменение масштаба острова
	fileprivate static var randomScaleFactor: CGFloat {
		let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 10)
		let randomNumber = CGFloat(distribution.nextInt()) / 10

		return randomNumber
	}

	//Метод - рандомное изменение угла поворота острова (с преобразованием градусов в радианы)
	fileprivate static func rotateForRandomAngle() -> SKAction {
		let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
		let randomNumber = CGFloat(distribution.nextInt())

		return SKAction.rotate(toAngle: randomNumber * CGFloat(Double.pi / 180), duration: 0)
	}
	// Метод задающий движение островов
	fileprivate static func move(from point: CGPoint) -> SKAction {
		let movePoint = CGPoint(x: point.x, y: -200)
		let moveDistance = point.y + 200
		let movementSpeed: CGFloat = 100.0
		let duration = moveDistance / movementSpeed
		let rezult = SKAction.move(to: movePoint, duration: TimeInterval(duration))
		return rezult
	}
}
