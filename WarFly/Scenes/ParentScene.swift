//
//  ParentScene.swift
//  WarFly
//
//  Created by Алексей Гуляев on 16.08.2024.
//

/*
 Я создал данный класс для того что бы убрать весь дублирующийся код сюда
 и тем самым использовать принцип DRY
 */


import SpriteKit

class ParentScene: SKScene {

	//создадим наш единсвенный экземпляр SceneManager
	//так же зададим сдесь константу sceneManager, к который мы будем обращаться
	//в методе touchesBegan, resume,

	//!!!можно дописать фукционал: и проверять если у нас запомненная сцена,
	//если нет то данная кропка срабатывать не будет!!!
	let sceneManager = SceneManager.shared

	//для того что бы вернуться назад зададим для нее переменную
	var backScene: SKScene?

	//для примера напишем функцию устновки хедера
	func setHeader(
		withName name: String?,
		andBackground backgroundName: String
	) {

		//добавим хедер
		let pauseButton = ButtonNode(titled: name, backGroundName: backgroundName)

		//создадим кнопку используя два нода (фон и ярлык)
		pauseButton.position = CGPoint(x: self.frame.midX, y: self.frame.midY + 150)
		self.addChild(pauseButton)
	}

	//зададим цвет нашего фона по умолчанию (что бы не прописывать его на асех сценах)
	override init(size: CGSize) {
		super.init(size: size)

		backgroundColor = SKColor(
			red: 0.15,
			green: 0.15,
			blue: 0.3,
			alpha: 1)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
