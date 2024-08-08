//
//  BitMaskKategory.swift
//  WarFly
//
//  Created by Алексей Гуляев on 03.08.2024.
//

import SpriteKit

extension SKPhysicsBody {
	var category: BitMaskKategory {
		get {
			return BitMaskKategory(rawValue: self.categoryBitMask)
		}
		set(newValue) {
			self.categoryBitMask = newValue.rawValue
		}
	}
}

//используется тип Uint32
//битовая маска берется из числе кратных 2 (1..2..4..8..16..32.....)
//напишем более универсальное представление для использования

struct BitMaskKategory: OptionSet {
	let rawValue: UInt32

	static let none		= BitMaskKategory(rawValue: 0 << 0)	//000000000000...00		0
	static let player	= BitMaskKategory(rawValue: 1 << 0)	//000000000000...01		1
	static let enemy	= BitMaskKategory(rawValue: 1 << 1)	//000000000000...10		2
	static let powerUp	= BitMaskKategory(rawValue: 1 << 2)	//000000000000..100		4
	static let shot		= BitMaskKategory(rawValue: 1 << 3)	//000000000000.1000		8
	static let all		= BitMaskKategory(rawValue: UInt32.max)	//000000000000.1000		8

}
