//
//  MenuScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 01.08.2024.
//

import SpriteKit

class MenuScene: SKScene {
	override func didMove(to view: SKView) {
		
		//Проверяем - загружены ли атласы
		if Assets.shared.isLoaded == false {
			//Подгружаем наши атласы
			Assets.shared.preloadAssets()
			Assets.shared.isLoaded = true
		}

		//добавим фон
		self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
		//добавим хедер
		let header = SKSpriteNode(imageNamed: "header1")
		
		//создадим кнопку используя два нода (фон и ярлык)
		header.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
		self.addChild(header)

		//перепишем наши кнопки так что бы не повторяться (DRY - Don't repeat your self)
		let titles = ["play", "options", "best"]

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
	
	//ловим действие
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		//ловим первое касание на текущем экране (место на которое мы нажали)
		let location = touches.first!.location(in: self)
		//метод addPoint позволяет получить обьект под той областью на которую мы нажали
		//(предположительно наша кнопка)
		let node = self.atPoint(location)
		//теперь проверяем что под этой областью надодиться нода "runButton"
		if node.name == "play" {
			//то осуществить переход на другую сцену crossFade (один из вариантов перехода)
			let transition = SKTransition.crossFade(withDuration: 1.0)
			//теперь создадим ту цену на которую хотим перейти с размерами нашей текущей сцены
			let gameScene = GameScene(size: self.size)
			//масштаб сцены
			gameScene.scaleMode = .aspectFill
			//осуществим сам переход с тем видом (transition) который мы ранее выбрали
			self.scene!.view?.presentScene(gameScene, transition: transition)
		}
	}

}
