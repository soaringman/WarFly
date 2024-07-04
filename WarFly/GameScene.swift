//
//  GameScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 27.06.2024.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    override func didMove(to view: SKView) {
		
		//конфигурирование подложки
		let screenCenterPoint = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
		let background = Background.populateBackground(at: screenCenterPoint)
		background.size = self.size
		self.addChild(background)

		//вычисляем расположение 5-ти островов (создаются рандомные коорднаты островов в пределах экрана)
		//Возможно дописать проверку на то, что бы острова не пересекались
		let screen = UIScreen.main.bounds
		for _ in 1...5 {
			let randomX: CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound:
																					Int(screen.size.width)))
			let randomY: CGFloat = CGFloat(GKRandomSource.sharedRandom().nextInt(upperBound:
																					Int(screen.size.height)))
			let island = Island.populateSprite(at: CGPoint(x: randomX, y: randomY))


			self.addChild(island)

			let cloud = Cloud.populateSprite(at: CGPoint(x: randomX, y: randomY))
			self.addChild(cloud)

		}
    }
}
