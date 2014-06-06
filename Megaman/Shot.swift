//
//  Shot.swift
//  Megaman
//
//  Created by Daniel L. Alves on 5/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import SpriteKit

class Shot : SKSpriteNode
{
    enum Direction : Int
    {
        case Left = -1
        case Right = 1
    }
    
    var onKillCallback: (Shot) -> Void
    
    init(onKillCallback: (Shot) -> Void)
    {
        self.onKillCallback = onKillCallback
        
        let tex = SKTexture(imageNamed: "megaman-shot")
        super.init(texture: tex, color: UIColor.whiteColor(), size: tex.size())
    }
    
    override func removeFromParent()
    {
        onKillCallback( self )
        super.removeFromParent()
    }
    
    func animate(direction: Direction, ownerDxPerSec: CGFloat)
    {
        let updateInterval: NSTimeInterval = 0.05
        let dx = CGFloat( CGFloat(direction.toRaw()) * ( 20.0 + ( ownerDxPerSec * CGFloat(updateInterval) )))
        
        let movementAction = SKAction.moveBy(CGVector( dx, 0.0 ),
                                             duration: updateInterval )
        
        let checkEndedAction = SKAction.runBlock({
            if( !self.scene.intersectsNode( self ) )
            {
                self.removeAllActions()
                self.removeFromParent()
            }
        })
        
        runAction( SKAction.sequence([ movementAction, checkEndedAction ]).forever() )
    }
}
