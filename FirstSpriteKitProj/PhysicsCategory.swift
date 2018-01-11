//
//  PhysicsCategory.swift
//  FirstSpriteKitProj
//
//  Created by Josiah Mory on 1/8/18.
//  Copyright © 2018 kickinbahk Productions. All rights reserved.
//

import Foundation

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
    static let Player    : UInt32 = 0b11      // 3
}
