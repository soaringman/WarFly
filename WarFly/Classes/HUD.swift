//
//  HUD.swift
//  WarFly
//
//  Created by Алексей Гуляев on 08.08.2024.
//

import SpriteKit

class HUD: SKNode {

	//создаем элементы для пользовательского интерфейса
	let scoreBackground = SKSpriteNode(imageNamed: "scores")
	let scoreLabel = SKLabelNode(text: "0")

	//добавим переменную отвечающую за очки и сделаем наблюдателя который будет наблюдать за изменением переменной
	//score, и как только она будет меняться он будет изменять значение scoreLabel.text и присваивать ему значение
	//score
	var score: Int = 0 {
		didSet {
			scoreLabel.text = score.description
		}
	}
	
	let menuButton = SKSpriteNode(imageNamed: "menu")
	let life1 = SKSpriteNode(imageNamed: "life")
	let life2 = SKSpriteNode(imageNamed: "life")
	let life3 = SKSpriteNode(imageNamed: "life")

	func configureUI(screenSize: CGSize) {
		//я корректировал позицию что бы не залезать на "остров"
		//можно еще было поиграться с масштабом

		//зададим нашу позицию относительно измененного далее анкорПоинта
		scoreBackground.position = CGPoint(
			x: scoreBackground.size.width + 10,
			y: screenSize.height - scoreBackground.size.height / 2 - 40)
		//сместим наш анкорПоинт
		scoreBackground.anchorPoint = CGPoint(x: 1.0, y: 0.5)
		scoreBackground.zPosition = 99
		addChild(scoreBackground)

		//наш ярлык с очками всегда долбен быть внутри нашего scoreBackground
		//для этого выравниваем наш ярлык по горизонтали и вертикали
		scoreLabel.horizontalAlignmentMode = .right
		scoreLabel.verticalAlignmentMode = .center
		//слегка подравниваем внутри (подобран опытным путем)
		scoreLabel.position = CGPoint(x: -10, y: 3)
		//зададим позицию по оси z
		scoreLabel.zPosition = 100
		//задаем фонт, предварительно его подсмотрев тут: iosfonts.com
		scoreLabel.fontName = "AmericanTypewriter-Bold"
		//зададим размер (подобран опытным путем)
		scoreLabel.fontSize = 30
		//добавим на экран
		scoreBackground.addChild(scoreLabel)


		//теперь добавим нашу кнопку "меню"
		menuButton.position = CGPoint(x: 20, y: 20)
		
		//так жа сместим наш анкор поинт
		//(обучно по умолчанию он находиться в центре фигуры)
		menuButton.anchorPoint = CGPoint(x: 0.0, y: 0.0)
		menuButton.zPosition = 100
		
		//добавим кнопку pause
		menuButton.name = "pause"

		addChild(menuButton)

		//и теперь добавим "жизни" для самолета
		let lifes = [life1, life2, life3]
		//метод enumerated позволяет возвращать сам элемент и его индекс
		for (index, life) in lifes.enumerated() {
			//мы шагаем от правой границы экрана по х влево на ширину звезды
			//и прокручивая это в цикле получаем смещение на 3, потом на 2
			//потом на 1 звезду, между звездами расстояние 3 поинта
			life.position = CGPoint(
				x: screenSize.width - 10 - CGFloat(index + 1) * (life.size.width + 3),
				y: 20)
			life.zPosition = 100
			life.anchorPoint = CGPoint(x: 0.0, y: 0.0)
			addChild(life)
		}
	}


}
