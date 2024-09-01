//
//  PauseScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 13.08.2024.
//

import SpriteKit

class PauseScene: ParentScene {

	override func didMove(to view: SKView) {

		//добавим хедер
		setHeader(withName: "pause", andBackground: "header_background")

		//перепишем наши кнопки так что бы не повторяться (DRY - Don't repeat your self)
		let titles = ["restart", "options", "resume"]

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

	// в этом методе мы исправляем то что при снятии с паузы у нас не меняется
	// флаг ipPaused на true и делаем это тут, предварительно проверяем что наша
	//сцена сохранена в нашем сингл тоне gameScene
	override func update(_ currentTime: TimeInterval) {
		if let gameScene = sceneManager.gameScene {
			if !gameScene.isPaused {
				gameScene.isPaused = true
			}
		}
	}

	//если не понятно смотри подробные комментарии в GameScene одноименном методе

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
			
		} else if node.name == "resume" {

			let transition = SKTransition.crossFade(withDuration: 1.0)
			//напишем проверку так как наша сцена является опциональной
			guard let gameScene = sceneManager.gameScene else { return }
			gameScene.scaleMode = .aspectFill
			self.scene!.view?.presentScene(gameScene, transition: transition)
		}
	}

}
