//
//  YellowShot.swift
//  WarFly
//
//  Created by Алексей Гуляев on 31.07.2024.
//

import SpriteKit

class YellowShot: Shot {

	init() {
		let currentTexputeAtlas = Assets.shared.yellowAmmoAltas
		super.init(textureAtlas: currentTexputeAtlas)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
