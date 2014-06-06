//
//  MegamanNode.swift
//  Megaman
//
//  Created by Daniel L. Alves on 3/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import SpriteKit

enum MegamanDirection : Int
{
    case Left = -1
    case Right = 1
}

class MegamanNode : SKSpriteNode
{
    let MAX_LIVE_SHOTS: Int = 3
    let TIME_TO_CROSS_SCREEN : CGFloat = 3.0
    
    // See megaman frames
    let MEGA_BUSTER_CANNON_OFFSET_Y : CGFloat = 18.0
    let MEGA_BUSTER_CANNON_HEIGHT : CGFloat = 2.0
    let MEGA_BUSTER_INITIAL_DIST_FROM_SHOT : CGFloat = 10.0
    
    // Animation keys
    let MOVEMENT_ANIM_KEY = "movement"
    let STATE_ANIM_KEY = "state"
    
    enum State
    {
        case Still
        case Running
        case Jumping
        case StillAndShooting
        case RunningAndShooting
        case JumpingAndShooting
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
    
    let jumpingFrames : SKTexture[]
    let jumpingAnimation : SKAction

    var state : State = .Still
    
    var liveShots: Int = 0
    
    let WALK_STEP : Float = 50.0
    
    let JUMP_HEIGHT : Float = 100.0
    let JUMP_DURATION : NSTimeInterval = 0.2
    
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
        
        jumpingFrames = [
            atlas.textureNamed( "megaman-06" )
        ]
        
        jumpingAnimation = SKAction.animateWithTextures( jumpingFrames, timePerFrame: 1.0 )
        
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
        super.init( texture: defaultFrame, color: UIColor.whiteColor(), size: defaultFrame.size())
        
        setScale(4.0)
    }

    func moveTo( destination: CGPoint )
    {
         faceLocation(destination)
        
        let duration = NSTimeInterval(( fabsf( destination.x - position.x ) / scene.size.width ) * TIME_TO_CROSS_SCREEN)
        
        run()
        runAction(SKAction.moveTo( CGPoint( x: destination.x, y: position.y ), duration: duration ),
                                   withKey: MOVEMENT_ANIM_KEY,
                                   optionalCompletion: { self.still() })
    }
    
    func moveOneStepTo( direction: MegamanDirection )
    {
        let step = Float(direction.toRaw()) * WALK_STEP
        let nextLocation = CGPoint(x: self.position.x + step, y: self.position.y)
        faceLocation( nextLocation )

        self.run()
        self.runAction(SKAction.moveTo( nextLocation, duration: 0.4 ), withKey: "movement", optionalCompletion: { self.still() })
    }
    
    func moveLeft()
    {
        moveOneStepTo( .Left )
    }
    
    func moveRight()
    {
        moveOneStepTo( .Right )
    }
    
    func still()
    {
        setState( .Still )
    }
    
    func run()
    {
        setState( .Running )
    }
    
    func jump()
    {
        setState( .Jumping )
        
        let groundPosition : CGPoint = self.position
        let airPosition = CGPoint( x: groundPosition.x, y: groundPosition.y + JUMP_HEIGHT)
        
        self.runAction(SKAction.moveTo( airPosition , duration: self.JUMP_DURATION ), withKey: "movement", optionalCompletion: {
            self.runAction(SKAction.moveTo( groundPosition, duration: self.JUMP_DURATION ), withKey: "movement", optionalCompletion: {
                self.still()
            })
        })
    }

    func shoot( destination: CGPoint)
    {
        var currentState = state
        
        let changedFacingDirection = faceLocation(destination)
        if changedFacingDirection && ((currentState == .Running) || (currentState == .RunningAndShooting))
        {
            currentState = .Still
        }
        
        if liveShots >= MAX_LIVE_SHOTS
        {
            return
        }
        
        switch currentState
        {
            case .Still, .StillAndShooting:
                setState( .StillAndShooting )
            
            case .Running, .RunningAndShooting:
                setState( .RunningAndShooting )
            
            case .Jumping, .JumpingAndShooting:
                setState( .JumpingAndShooting )
        }
        
        let shot = Shot(onKillCallback: {( dyingShot ) in
            self.liveShots -= 1
        })
        
        shot.xScale = xScale
        shot.yScale = yScale
        parent.addChild(shot)
        
        shot.position.y = ( position.y + size.height / 2.0 ) - ( MEGA_BUSTER_CANNON_OFFSET_Y * yScale ) - (( MEGA_BUSTER_CANNON_HEIGHT * yScale  ) / 2.0)
        
        let megamanDxPerSec = scene.size.width / TIME_TO_CROSS_SCREEN
        let shotOffset = ( size.width / 2.0 ) + ( shot.size.width / 2.0 ) + MEGA_BUSTER_INITIAL_DIST_FROM_SHOT
        let facingDir : Shot.Direction = xScale < 0.0 ? .Left : .Right
        
        shot.position.x = position.x + ( CGFloat(facingDir.toRaw()) * shotOffset )
        shot.animate( facingDir, ownerDxPerSec: megamanDxPerSec )
        
        ++liveShots
    }
    
    func faceLocation(location: CGPoint) -> Bool
    {
        let wasFacingLeft = xScale < 0.0
        
        var multiplierForDirection : CGFloat
        if location.x <= position.x
        {
            // facing left
            multiplierForDirection = -1.0
        }
        else
        {
            // facing right
            multiplierForDirection = 1.0
        }
        
        xScale = CGFloat(CGFloat(fabsf(xScale)) * multiplierForDirection)
        
        return wasFacingLeft != ( xScale < 0.0 )
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
                removeActionForKey(MOVEMENT_ANIM_KEY)
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
            case .Jumping:
                finalAction = jumpingAnimation.forever()
            
            case .StillAndShooting, .JumpingAndShooting:
                removeActionForKey(MOVEMENT_ANIM_KEY)
                
                completion = {
                    self.removeActionForKey(self.STATE_ANIM_KEY)
                    self.still()
                }
                finalAction = stillAndShootingAnimation
            
            case .RunningAndShooting:
                completion = {
                    self.removeActionForKey(self.STATE_ANIM_KEY)
                    self.run()
                }
                finalAction = runningAndShootingAnimation
        }
        
        runAction(finalAction, withKey: STATE_ANIM_KEY, optionalCompletion: completion )
    }
}
















































