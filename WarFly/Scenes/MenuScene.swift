//
//  MenuScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 01.08.2024.
//

import SpriteKit

class MenuScene: SKScene {
	override func didMove(to view: SKView) {
		//Подгружаем наши атласы
		Assets.shared.preloadAssets()
		
		self.backgroundColor = SKColor(red: 0.15, green: 0.15, blue: 0.3, alpha: 1.0)
		let texture = SKTexture(imageNamed: "play")
		let button = SKSpriteNode(texture: texture)
		button.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
		button.name = "runButton"
		self.addChild(button)
	}
	//ловим действие
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		//ловим первое касание на текущем экране (место на которое мы нажали)
		let location = touches.first!.location(in: self)
		//метод addPoint позволяет получить обьект под той областью на которую мы нажали
		//(предположительно наша кнопка)
		let node = self.atPoint(location)
		//теперь проверяем что под этой областью надодиться нода "runButton"
		if node.name == "runButton" {
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
