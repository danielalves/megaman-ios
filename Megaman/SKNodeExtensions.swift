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
        if let completion = optionalCompletion
        {
            let completionAction = SKAction.runBlock( completion )
            let compositeAction = SKAction.sequence([ action, completionAction ])
            runAction( compositeAction, withKey: withKey )
        }
        else
        {
            runAction( action, withKey: withKey )
        }
    }
}
