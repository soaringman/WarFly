//
//  Enemy.swift
//  WarFly
//
//  Created by Алексей Гуляев on 23.07.2024.
//

import SpriteKit

class Enemy: SKSpriteNode {
	static var textureAtlas: SKTextureAtlas?

	init() {
		let textureEnemy = Enemy.textureAtlas?.textureNamed("airplane_4ver2_13")
		super.init(texture: textureEnemy, color: .clear, size: CGSize(width: 221, height: 204))
		self.xScale = 0.5
		self.yScale = -0.5
		self.zPosition = 20
		self.name = "spriteEnemy"
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
