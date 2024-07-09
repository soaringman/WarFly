//
//  Cloud.swift
//  WarFly
//
//  Created by Алексей Гуляев on 04.07.2024.
//

import SpriteKit
import GameplayKit

protocol IGameBackgroundSpritable  {
	static func populate() -> Self
	//добавим метод для рандомной генерации обьектов выше сцены (что бы было чему вылетать на встречу самолету)
	static func randomPoint() -> CGPoint
}

extension IGameBackgroundSpritable {
	//реализуем  метод для рандомной генерации обьектов выше сцены (что бы было чему вылетать на встречу самолету)
	static func randomPoint() -> CGPoint {
		//найдем границы экрана
		let screen = UIScreen.main.bounds
		//напишем константу в которую будем генерить наши радомные обьекты в пределах
		//от +100 вверх от экрана до +200 вверх от экрана
		let disribution = GKRandomDistribution(
			lowestValue: Int(screen.size.height) + 100,
			highestValue: Int(screen.size.height) + 200
		)
		//теперь применим эту генерацию для оси y
		//next используется для того, что бы мы смогли сгенерировать следующее значение в указанном выше диапазоне
		let y = CGFloat(disribution.nextInt())
		//Этот метод отличается от предыдущего тем, что мы генерируем значения от нуля до ширины экрана
		//и он нам генерирует значения в диапазоне ширины нашего экрана
		let x = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound: Int(screen.size.width)))
		return CGPoint(x: x, y: y)
	}
}

final class Cloud: SKSpriteNode, IGameBackgroundSpritable {

	static func populate() -> Cloud {
		let cloudImageName = configureName()
		let cloud = Cloud(imageNamed: cloudImageName)

		//конфигурируем облако
		cloud.setScale(randomScaleFactor)
		cloud.position = randomPoint()
		cloud.zPosition = 10
		cloud.run(move(from: cloud.position))

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
		let movementSpeed: CGFloat = 150.0
		let duration = moveDistance / movementSpeed
		let rezult = SKAction.move(to: movePoint, duration: TimeInterval(duration))
		return rezult
	}
}
