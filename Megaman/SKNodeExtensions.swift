//
//  SKNodeExtensions.swift
//  Megaman
//
//  Created by Daniel L. Alves on 4/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import SpriteKit

extension SKNode
{
    func runAction( action: SKAction!, withKey: String!, completion: dispatch_block_t! )
    {
        var completionAction = SKAction.runBlock( completion )
        var compositeAction = SKAction.sequence([ action, completionAction ])
        self.runAction( compositeAction, withKey: withKey )
    }
}
