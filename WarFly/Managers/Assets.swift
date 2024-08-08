//
//  Assets.swift
//  WarFly
//
//  Created by Алексей Гуляев on 01.08.2024.
//

import SpriteKit

//класс для предзагрузки всех наших атласов
class Assets {
	static let shared = Assets()
	let playerPlaneAltas = SKTextureAtlas(named: "PlayerPlane")
	let yellowAmmoAltas = SKTextureAtlas(named: "YellowAmmo")
	let enemy_1Altas = SKTextureAtlas(named: "Enemy_1")
	let enemy_2Altas = SKTextureAtlas(named: "Enemy_2")
	let bluePowerUpAltas = SKTextureAtlas(named: "BluePowerUp")
	let greenPowerUpAltas = SKTextureAtlas(named: "GreenPowerUp")

	func preloadAssets() {
		playerPlaneAltas.preload {print("playerPlaneAltas is preloaded")}
		yellowAmmoAltas.preload {print("yellowAmmoAltas is preloaded")}
		enemy_1Altas.preload {print("enemy_1Altas is preloaded")}
		enemy_2Altas.preload {print("enemy_2Altas is preloaded")}
		bluePowerUpAltas.preload {print("bluePowerUpAltas is preloaded")}
		greenPowerUpAltas.preload {print("greenPowerUpAltas is preloaded")}
	}
}
