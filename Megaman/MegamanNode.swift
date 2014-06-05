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
    case Running
    case Jumping
    case StillAndShooting
    case RunningAndShooting
}

class MegamanNode : SKSpriteNode
{
    var atlas : SKTextureAtlas
    
    var stillFrames : SKTexture[]
    var stillAnimation : SKAction
    
    var jumpingFrames : SKTexture[]
    var jumpingAnimation : SKAction
    
    var stillAndShootingFrames : SKTexture[]
    var stillAndShootingAnimation : SKAction

    var startRunningFrames : SKTexture[]
    var startRunningAnimation : SKAction
    
    var runningFrames : SKTexture[]
    var runningAnimation : SKAction
    
    var runningAndShootingFrames : SKTexture[]
    var runningAndShootingAnimation : SKAction
    
    var state : MegamanState = .Still
    
    var liveShots: Int = 0
    
    let MAX_LIVE_SHOTS: Int = 3
    let TIME_TO_CROSS_SCREEN = Float(3.0)
    
    init()
    {
        atlas = SKTextureAtlas(named: "megaman")

        stillFrames = [
            atlas.textureNamed( "megaman-00" ),
            atlas.textureNamed( "megaman-01" )
        ]
        
        stillAnimation = SKAction.sequence([
            SKAction.animateWithTextures( [atlas.textureNamed( "megaman-00" )], timePerFrame: 3.0 ),
            SKAction.animateWithTextures( [atlas.textureNamed( "megaman-01" )], timePerFrame: 0.1 )
        ])
        
        stillAndShootingFrames = [
            atlas.textureNamed( "megaman-07" )
        ]
        
        stillAndShootingAnimation = SKAction.animateWithTextures( stillAndShootingFrames, timePerFrame: 0.2 )

        startRunningFrames = [
            atlas.textureNamed( "megaman-02" )
        ]
        
        startRunningAnimation = SKAction.animateWithTextures( startRunningFrames, timePerFrame: 0.1 )
        
        runningFrames = [
            atlas.textureNamed( "megaman-03" ),
            atlas.textureNamed( "megaman-04" ),
            atlas.textureNamed( "megaman-05" ),
            atlas.textureNamed( "megaman-04" )
        ]

        runningAnimation = SKAction.animateWithTextures( runningFrames, timePerFrame: 0.1 )
        
        runningAndShootingFrames = [
            atlas.textureNamed( "megaman-08" ),
            atlas.textureNamed( "megaman-09" ),
            atlas.textureNamed( "megaman-10" ),
            atlas.textureNamed( "megaman-09" )
        ]
        
        runningAndShootingAnimation = SKAction.animateWithTextures( runningAndShootingFrames, timePerFrame: 0.1 )
        
        let defaultFrame = stillFrames[0]
        super.init( texture: defaultFrame, color: UIColor.whiteColor(), size: CGSize(width: 24, height: 24))
        
        self.setScale(4.0)
    }

    func moveTo( location: CGPoint )
    {
        var duration = NSTimeInterval(( Float.abs( location.x - self.position.x ) / self.scene.size.width ) * TIME_TO_CROSS_SCREEN)
        
        self.run()
        self.runAction(SKAction.moveTo( CGPoint( x: location.x, y: self.position.y ), duration: duration ),
                       withKey: "movement",
                       optionalCompletion: { self.still() })
    }
    
    func still()
    {
        setState( .Still )
    }
    
    func run()
    {
        setState( .Running )
    }

    func shoot()
    {
        if( liveShots >= MAX_LIVE_SHOTS )
        {
            return
        }
        
        switch( state )
        {
            case .Still, .StillAndShooting:
                setState( .StillAndShooting )
            
            case .Running, .RunningAndShooting:
                setState( .RunningAndShooting )
        }
        
        var shot = Shot(onKillCallback: { self.liveShots -= 1 } )
        
        shot.xScale = self.xScale
        shot.yScale = self.yScale
        self.parent.addChild(shot)
        
        shot.anchorPoint = CGPoint( x: 0.0, y: 1.0 )
        shot.position.y = self.frame.origin.y + ( shot.size.height / 2.0 ) + ( 10.0 * self.yScale )
        
        var megamanDx : CGFloat = 160.0
        
        if( self.xScale < 0.0 )
        {
            shot.position.x = CGRectGetMinX( self.frame ) - ( shot.size.width / 2.0 ) - 10.0
            shot.animate( .Left, ownerDxPerSec: megamanDx )
        }
        else
        {
            shot.position.x = CGRectGetMaxX( self.frame ) + ( shot.size.width / 2.0 ) + 10.0
            shot.animate( .Right, ownerDxPerSec: megamanDx )
        }
        
        ++liveShots
    }
    
    func faceLocation(location: CGPoint)
    {
        var multiplierForDirection : CGFloat
        
        var megamanX = CGRectGetMidX(self.frame)
        if( location.x <= megamanX )
        {
            // facing left
            multiplierForDirection = -1
        }
        else
        {
            // facing right
            multiplierForDirection = 1
        }
        
        self.xScale = Float.abs(self.xScale) * multiplierForDirection
    }
    
    func setState(newState: MegamanState)
    {
        if( newState == state )
        {
            return
        }
        
        let previousState = state
        state = newState
        
        var finalAction : SKAction
        var completion: dispatch_block_t? = nil
        switch( state )
        {
            case .Still:
                finalAction = stillAnimation.forever()

            case .Running:
                let running = runningAnimation.forever()
                
                if( previousState == .Still )
                {
                    finalAction = SKAction.sequence([ startRunningAnimation, running ])
                }
                else
                {
                    finalAction = running
                }
            case .Jumping:
                finalAction = SKAction.repeatActionForever(jumpingAnimation)
            
            case .StillAndShooting:
                completion = { self.removeActionForKey("state"); self.still() }
                finalAction = stillAndShootingAnimation
            
            case .RunningAndShooting:
                completion = { self.removeActionForKey("state"); self.run() }
                finalAction = runningAndShootingAnimation
        }
        
        self.runAction(finalAction, withKey: "state", optionalCompletion: completion )
    }
}
















































