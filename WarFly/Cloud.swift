//
//  Cloud.swift
//  WarFly
//
//  Created by Алексей Гуляев on 04.07.2024.
//

import SpriteKit
import GameplayKit

protocol IGameBackgroundSpritable  {
	static func populateSprite(at point: CGPoint) -> Self
}
final class Cloud: SKSpriteNode, IGameBackgroundSpritable {

	static func populateSprite(at point: CGPoint) -> Cloud {
		let cloudImageName = configureName()
		let cloud = Cloud(imageNamed: cloudImageName)

		//конфигурируем облако
		cloud.setScale(randomScaleFactor)
		cloud.position = point
		cloud.zPosition = 10
		cloud.run(move(from: point))

		return cloud
	}
	//Метод - рандомное измение облаков (имени выводимого облака)
	fileprivate static func configureName() -> String {
		let distribution = GKRandomDistribution(lowestValue: 1, highestValue: 3)
		let randomNumber = distribution.nextInt()
		let imageName = "cl" + "\(randomNumber)"

		return imageName
	}
	// Метод - Рандомное изменение масштаба облака
	fileprivate static var randomScaleFactor: CGFloat {
		let distribution = GKRandomDistribution(lowestValue: 20, highestValue: 30)
		let randomNumber = CGFloat(distribution.nextInt()) / 10

		return randomNumber
	}

	//Метод - движение облаков
	fileprivate static func move(from point: CGPoint) -> SKAction {
		let movePoint = CGPoint(x: point.x, y: -200)
		let moveDistance = point.y + 200
		let movementSpeed: CGFloat = 15.0
		let duration = moveDistance / movementSpeed
		let rezult = SKAction.move(to: movePoint, duration: TimeInterval(duration))
		return rezult
	}
}
