//
//  MegamanNode.swift
//  Megaman
//
//  Created by Daniel L. Alves on 3/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import SpriteKit

class MegamanNode : SKSpriteNode
{
    let MAX_LIVE_SHOTS: Int = 3
    let TIME_TO_CROSS_SCREEN = Float(3.0)
    
    enum State
    {
        case Still
        case Running
        case StillAndShooting
        case RunningAndShooting
    }
    
    let atlas : SKTextureAtlas
    
    let stillFrames : SKTexture[]
    let stillAnimation : SKAction
    
    let stillAndShootingFrames : SKTexture[]
    let stillAndShootingAnimation : SKAction

    let startRunningFrames : SKTexture[]
    let startRunningAnimation : SKAction
    
    let runningFrames : SKTexture[]
    let runningAnimation : SKAction
    
    let runningAndShootingFrames : SKTexture[]
    let runningAndShootingAnimation : SKAction
    
    var state : State = .Still
    
    var liveShots: Int = 0

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
        
        setScale(4.0)
    }

    func moveTo( destination: CGPoint )
    {
        let duration = NSTimeInterval(( Float.abs( destination.x - position.x ) / scene.size.width ) * TIME_TO_CROSS_SCREEN)
        
        run()
        runAction(SKAction.moveTo( CGPoint( x: destination.x, y: position.y ), duration: duration ),
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
        if liveShots >= MAX_LIVE_SHOTS
        {
            return
        }
        
        switch state
        {
            case .Still, .StillAndShooting:
                setState( .StillAndShooting )
            
            case .Running, .RunningAndShooting:
                setState( .RunningAndShooting )
        }
        
        let shot = Shot(onKillCallback: {( dyingShot ) in
            self.liveShots -= 1
        })
        
        shot.xScale = xScale
        shot.yScale = yScale
        parent.addChild(shot)
        
        shot.anchorPoint = CGPoint( x: 0.0, y: 1.0 )
        shot.position.y = frame.origin.y + ( shot.size.height / 2.0 ) + ( 10.0 * yScale )
        
        let megamanDxPerSec : CGFloat = scene.size.width / TIME_TO_CROSS_SCREEN
        
        if xScale < 0.0
        {
            shot.position.x = CGRectGetMinX( frame ) - ( shot.size.width / 2.0 ) - 10.0
            shot.animate( .Left, ownerDxPerSec: megamanDxPerSec )
        }
        else
        {
            shot.position.x = CGRectGetMaxX( frame ) + ( shot.size.width / 2.0 ) + 10.0
            shot.animate( .Right, ownerDxPerSec: megamanDxPerSec )
        }
        
        ++liveShots
    }
    
    func faceLocation(location: CGPoint)
    {
        var multiplierForDirection : CGFloat
        
        let megamanX = CGRectGetMidX(frame)
        if location.x <= megamanX
        {
            // facing left
            multiplierForDirection = -1
        }
        else
        {
            // facing right
            multiplierForDirection = 1
        }
        
        xScale = Float.abs(xScale) * multiplierForDirection
    }
    
    func setState(newState: State)
    {
        if newState == state
        {
            return
        }
        
        let previousState = state
        state = newState
        
        var finalAction : SKAction
        var completion: dispatch_block_t? = nil
        switch state
        {
            case .Still:
                finalAction = stillAnimation.forever()

            case .Running:
                let running = runningAnimation.forever()
                
                if previousState == .Still
                {
                    finalAction = SKAction.sequence([ startRunningAnimation, running ])
                }
                else
                {
                    finalAction = running
                }
            
            case .StillAndShooting:
                completion = {
                    self.removeActionForKey("state")
                    self.still()
                }
                finalAction = stillAndShootingAnimation
            
            case .RunningAndShooting:
                completion = {
                    self.removeActionForKey("state")
                    self.run()
                }
                finalAction = runningAndShootingAnimation
        }
        
        runAction(finalAction, withKey: "state", optionalCompletion: completion )
    }
}
















































