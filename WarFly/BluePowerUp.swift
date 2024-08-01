//
//  BluePowerUp.swift
//  WarFly
//
//  Created by Алексей Гуляев on 30.07.2024.
//
import SpriteKit

class BluePowerUp: PowerUp {

	init() {
		let blueTextureAtlas = Assets.shared.bluePowerUpAltas
		super.init(textureAtlas: blueTextureAtlas)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
