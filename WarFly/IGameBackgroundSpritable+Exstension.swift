//
//  IGameBackgroundSpritable+Exstension.swift
//  WarFly
//
//  Created by Алексей Гуляев on 11.07.2024.
//

import SpriteKit
import GameplayKit

protocol IGameBackgroundSpritable  {
	static func populate(at point: CGPoint?) -> Self
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
			lowestValue: Int(screen.size.height) + 400,
			highestValue: Int(screen.size.height) + 500
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
