//
//  BestScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 01.09.2024.
//

import SpriteKit

class BestScene: ParentScene {

	//добавляю массив лучших игроков
	var places = [10, 100, 1000]

	override func didMove(to view: SKView) {

		//добавим хедер
		setHeader(withName: "best", andBackground: "header_background")

		//перепишем наши кнопки так что бы не повторяться (DRY - Don't repeat your self)
		let titles = ["back"]

		for (index, title) in titles.enumerated() {

			//добавим кнопку play путем добавления двух нодов (ярлыка и фона)
			let button = ButtonNode(
				titled: title,
				backGroundName: "button_background"
			)

			button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - 200 + CGFloat(100 * index))
			button.name = title

			// имя ярлыка так же play (это сделано для того что бы если я нажимаю на ярлык - действие тоже срабатывает)
			button.label.name = title
			addChild(button)
		}

		//отсоритируем массив лучших игроков с лева на право, используя функцию высшего порядка с ассоциативаными
		//параметрами, а так же обрежем наш массив, до трех топовых результатов, так как он может пополняться
		let topPlaces = places.sorted { $0 > $1 }.prefix(3)

		for (index, value) in topPlaces.enumerated() {
			let l = SKLabelNode(text: value.description)
			l.fontColor = UIColor(
				red: 219 / 255,
				green: 226 / 255,
				blue: 215 / 255,
				alpha: 1.0
			)
			l.fontName = "AmericanTypewriter-Bold"
			l.fontSize = 30
			l.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(index * 60))
			addChild(l)
		}
	}

	//если не понятно смотри подробные комментарии в GameScene одноименном методе

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		let location = touches.first!.location(in: self)
		let node = self.atPoint(location)

		if node.name == "back" {

			let transition = SKTransition.crossFade(withDuration: 1.0)
			guard let backScene = backScene else { return }
			backScene.scaleMode = .aspectFill
			self.scene!.view?.presentScene(backScene, transition: transition)
		}
	}

}
