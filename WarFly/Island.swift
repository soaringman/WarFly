//
//  Island.swift
//  WarFly
//
//  Created by Алексей Гуляев on 03.07.2024.
//

import SpriteKit
import GameplayKit

final class Island: SKSpriteNode, IGameBackgroundSpritable {

	static func populateSprite(at point: CGPoint) -> Island {
		let islandImageName = configureName()
		let island = Island(imageNamed: islandImageName)

		//конфигурируем остров
		island.setScale(randomScaleFactor)
		island.position = point
		island.zPosition = 1
		island.run(rotateForRandomAngle())

		return island
	}
	//Метод - рандомное измение островов (имени выводимого острова)
	static func configureName() -> String {
		let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 4)
		let randomNumber = distribution.nextInt()
		let imageName = "is" + "\(randomNumber)"

		return imageName
	}
	// Метод - Рандомное изменение масштаба острова
	static var randomScaleFactor: CGFloat {
		let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 10)
		let randomNumber = CGFloat(distribution.nextInt()) / 10

		return randomNumber
	}

	//Метод - рандомное изменение угла поворота острова (с преобразованием градусов в радианы)
	static func rotateForRandomAngle() -> SKAction {
		let distribution = GKRandomDistribution(lowestValue: 0, highestValue: 360)
		let randomNumber = CGFloat(distribution.nextInt())

		return SKAction.rotate(toAngle: randomNumber * CGFloat(Double.pi / 180), duration: 0)
	}
}
