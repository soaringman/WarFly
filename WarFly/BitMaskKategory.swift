//
//  BitMaskKategory.swift
//  WarFly
//
//  Created by Алексей Гуляев on 03.08.2024.
//

import Foundation

//используется тип Uint32
//битовая маска берется из числе крастных 2 (1..2..4..8..16..32.....)
struct BitMaskKategory {
	static let player: UInt32 = 0x1 << 0	//000000000000...01		1
	static let enemy: UInt32 = 0x1 << 1		//000000000000...10		2
	static let powerUp: UInt32 = 0x1 << 2	//000000000000..100		4
	static let shot: UInt32 = 0x1 << 3		//000000000000.1000		8
}
