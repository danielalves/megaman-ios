//
//  MegamanNode.swift
//  Megaman
//
//  Created by Daniel L. Alves on 3/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import SpriteKit

enum MegamanState : Int
{
    case Still = 0
    case StartRunning
    case Running
}

class MegamanNode : SKSpriteNode
{
    var atlas : SKTextureAtlas
    
    var stillFrames : SKTexture[]
    var stillAnimation : SKAction

    var startRunningFrames : SKTexture[]
    var startRunningAnimation : SKAction
    
    var runningFrames : SKTexture[]
    var runningAnimation : SKAction
    
    var state : MegamanState = .Still
    
    init()
    {
        atlas = SKTextureAtlas(named: "megaman")

        stillFrames = [
            atlas.textureNamed( "megaman-frame-00.png" ),
            atlas.textureNamed( "megaman-frame-01.png" )
        ]
        
        stillAnimation = SKAction.sequence([
            SKAction.animateWithTextures( [atlas.textureNamed( "megaman-frame-00.png" )], timePerFrame: 3.0 ),
            SKAction.animateWithTextures( [atlas.textureNamed( "megaman-frame-01.png" )], timePerFrame: 0.1 )
        ])

        startRunningFrames = [
            atlas.textureNamed( "megaman-frame-02.png" )
        ]
        
        startRunningAnimation = SKAction.animateWithTextures( startRunningFrames, timePerFrame: 0.05 )
        
        runningFrames = [
            atlas.textureNamed( "megaman-frame-03.png" ),
            atlas.textureNamed( "megaman-frame-04.png" ),
            atlas.textureNamed( "megaman-frame-05.png" ),
            atlas.textureNamed( "megaman-frame-04.png" )
        ]

        runningAnimation = SKAction.animateWithTextures( runningFrames, timePerFrame: 0.1 )
        
        let defaultFrame = stillFrames[0]
        super.init( texture: defaultFrame, color: UIColor.whiteColor(), size: CGSize(width: 24, height: 24))
        
        self.setScale(4.0)
    }

    func moveTo( location: CGPoint, duration: NSTimeInterval )
    {
        self.run()
        self.runAction(SKAction.moveTo( location, duration: duration ),
                       withKey: "movement",
                       completion: { self.still() })
    }
    
    func still()
    {
        state = .Still
        self.runAction(SKAction.repeatActionForever(stillAnimation), withKey: "state")
    }
    
    func run()
    {
        if( state != .Running )
        {
            state = .Running
            self.runAction(SKAction.repeatActionForever(runningAnimation), withKey: "state")
        }
    }
}
