//
//  Shot.swift
//  Megaman
//
//  Created by Daniel L. Alves on 5/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import SpriteKit

enum ShotDirection : Int
{
    case Left = -1
    case Right = 1
}

class Shot : SKSpriteNode
{
    var onKillCallback: () -> Void
    
    init(onKillCallback: () -> Void)
    {
        self.onKillCallback = onKillCallback
        
        let tex = SKTexture(imageNamed: "megaman-shot")
        super.init(texture: tex, color: UIColor.whiteColor(), size: tex.size())
    }
    
    override func removeFromParent() -> Void
    {
        onKillCallback()
        super.removeFromParent()
    }
    
    func animate(direction: ShotDirection, ownerDxPerSec: CGFloat)
    {
        let updateInterval: NSTimeInterval = 0.05
        var dx = CGFloat( CGFloat(direction.toRaw()) * ( 20.0 + ( ownerDxPerSec * CGFloat(updateInterval) )))
        
        var movementAction = SKAction.moveBy(CGVector( dx, 0.0 ),
                                             duration: updateInterval )
        var checkEndedAction = SKAction.runBlock({
            if( !self.scene.intersectsNode( self ) )
            {
                self.removeAllActions()
                self.removeFromParent()
            }
        })
        
        self.runAction( SKAction.sequence([ movementAction, checkEndedAction ]).forever() )
    }
}
