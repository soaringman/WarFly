//
//  GameOverScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 10.09.2024.
//

import SpriteKit

class GameOverScene: ParentScene {

	override func didMove(to view: SKView) {

		//добавим хедер
		setHeader(withName: "Game Over", andBackground: "header_background")

		//перепишем наши кнопки так что бы не повторяться (DRY - Don't repeat your self)
		let titles = ["restart", "options", "best"]

		for (index, title) in titles.enumerated() {

			//добавим кнопку play путем добавления двух нодов (ярлыка и фона)
			let button = ButtonNode(
				titled: title,
				backGroundName: "button_background"
			)

			button.position = CGPoint(x: self.frame.midX, y: self.frame.midY - CGFloat(100 * index))
			button.name = title

			// имя ярлыка так же play (это сделано для того что бы если я нажимаю на ярлык - действие тоже срабатывает)
			button.label.name = title
			addChild(button)
		}
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		let location = touches.first!.location(in: self)
		let node = self.atPoint(location)

		if node.name == "restart" {

			//когда мы перезапускаем иггру нам так же нужно очистить нашу gameScene,
			//для последующей записи туда новой gameScene и правильной отработки проверки в gameScene строка 29
			sceneManager.gameScene = nil
			let transition = SKTransition.crossFade(withDuration: 1.0)
			let gameScene = GameScene(size: self.size)
			gameScene.scaleMode = .aspectFill
			self.scene!.view?.presentScene(gameScene, transition: transition)

		} else if node.name == "options" {

			let transition = SKTransition.crossFade(withDuration: 1.0)
			let optionsScene =  OptionsScene(size: self.size)

			//В этом месте мы говорим что обратной сценой (то место куда мы вернемся) для нашей сцены будет
			//она сама
			optionsScene.backScene = self
			optionsScene.scaleMode = .aspectFill
			self.scene!.view?.presentScene(optionsScene, transition: transition)

		} else if node.name == "best" {

			let transition = SKTransition.crossFade(withDuration: 1.0)
			let bestScene = BestScene(size: self.size)
			bestScene.backScene = self
			bestScene.scaleMode = .aspectFill
			self.scene!.view?.presentScene(bestScene, transition: transition)
		}
	}


}
