//
//  SKActionExtensions.swift
//  Megaman
//
//  Created by Daniel L. Alves on 5/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import SpriteKit

extension SKAction
{
    func forever() -> SKAction!
    {
        return SKAction.repeatActionForever( self )
    }
}
