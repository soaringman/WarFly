//
//  ButtonNode.swift
//  WarFly
//
//  Created by Алексей Гуляев on 10.08.2024.
//

import SpriteKit

class ButtonNode: SKSpriteNode {
	
	//сконфигурируем ряд свойств через кложуру
	let label: SKLabelNode = {

		//создадим ярлык
		let l = SKLabelNode(text: "")
		l.fontColor = UIColor(
			red: 219 / 255,
		    green: 226 / 255,
			blue: 215 / 255,
			alpha: 1.0
		)
		l.fontName = "AmericanTypewriter-Bold"
		l.fontSize = 30
		l.horizontalAlignmentMode = .center
		l.verticalAlignmentMode = .center
		l.zPosition = 2
		return l
	}()

	init(titled title: String?, backGroundName: String) {

		let texture =  SKTexture(imageNamed: backGroundName)
		super .init(texture: texture, color: .clear, size: texture.size())

		//напишем извлечение опционала
		if let title = title {
			//все буквы заглавные
			label.text = title.uppercased()
		}
		addChild(label)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
