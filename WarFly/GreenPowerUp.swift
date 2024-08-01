//
//  GreenPowerUp.swift
//  WarFly
//
//  Created by Алексей Гуляев on 30.07.2024.
//
import SpriteKit

class GreenPowerUp: PowerUp {

	init() {
		let greenTextureAtlas = Assets.shared.greenPowerUpAltas
		super.init(textureAtlas: greenTextureAtlas)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
