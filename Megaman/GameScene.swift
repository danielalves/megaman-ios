//
//  GameScene.swift
//  Megaman
//
//  Created by Daniel L. Alves on 3/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import SpriteKit

class GameScene : SKScene
{    
    var megaman = MegamanNode()
    var timeToCrossScreen = Float(3.0)
    
    override func didMoveToView( view: SKView )
    {
        self.addChild( megaman )        
        
        megaman.position = CGPoint( x: self.frame.width / 2.0, y: self.frame.height / 2.0 )
        megaman.still()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent)
    {
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
    {
        var location = touches.anyObject().locationInNode(self)
        var multiplierForDirection : CGFloat
        
        var megamanX = CGRectGetMidX(megaman.frame)
        if( location.x <= megamanX )
        {
            // walk left
            multiplierForDirection = -1
        }
        else
        {
            // walk right
            multiplierForDirection = 1
        }
        
        megaman.xScale = Float.abs(megaman.xScale) * multiplierForDirection

        var duration = NSTimeInterval(( Float.abs( location.x - megamanX ) / self.frame.size.width ) * timeToCrossScreen)

        megaman.moveTo( CGPoint( x: location.x, y: megaman.position.y ), duration: duration )
    }
   
    override func update(currentTime: CFTimeInterval)
    {
    }
}
