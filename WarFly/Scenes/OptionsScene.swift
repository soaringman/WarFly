//
//  OptionsScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 16.08.2024.
//

import SpriteKit

class OptionsScene: ParentScene {

	override func didMove(to view: SKView) {

		//добавим хедер
		setHeader(withName: "options", andBackground: "header_background")

		//добавим кнопку music путем добавления двух нодов (ярлыка и фона)
		let music = ButtonNode(
			titled: nil,
			backGroundName: "music"
		)

		music.position = CGPoint(
			x: self.frame.midX - 50,
			y: self.frame.midY
		)
		music.name = "music"
		music.label.isHidden = true
		addChild(music)

		//добавим кнопку sound путем добавления двух нодов (ярлыка и фона)
		let sound = ButtonNode(
			titled: nil,
			backGroundName: "sound"
		)

		sound.position = CGPoint(
			x: self.frame.midX + 50,
			y: self.frame.midY
		)
		sound.name = "sound"
		sound.label.isHidden = true
		addChild(sound)

		//добавим кнопку back путем добавления двух нодов (ярлыка и фона)
		let back = ButtonNode(
			titled: "back",
			backGroundName: "button_background"
		)

		back.position = CGPoint(
			x: self.frame.midX,
			y: self.frame.midY - 100
		)
		back.name = "back"
		back.label.name = "back"
		addChild(back)
	}

	//если не понятно смотри подробные комментарии в GameScene одноименном методе

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

		let location = touches.first!.location(in: self)
		let node = self.atPoint(location)

		if node.name == "music" {
			print("music")
		} else if node.name == "sound" {
			print("sound")
		} else if node.name == "back" {

			let transition = SKTransition.crossFade(withDuration: 1.0)
			guard let backScene = backScene else { return }
			backScene.scaleMode = .aspectFill
			self.scene!.view?.presentScene(backScene, transition: transition)
		}
	}


}
