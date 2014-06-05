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
    func runAction( action: SKAction!, withKey: String!, optionalCompletion: dispatch_block_t? )
    {
        if let completion = optionalCompletion?
        {
            var completionAction = SKAction.runBlock( completion )
            var compositeAction = SKAction.sequence([ action, completionAction ])
            self.runAction( compositeAction, withKey: withKey )
        }
        else
        {
            self.runAction( action, withKey: withKey )
        }
    }
}
