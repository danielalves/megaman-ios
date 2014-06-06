//
//  GameScene.swift
//  Megaman
//
//  Created by Daniel L. Alves on 3/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import SpriteKit

enum SwipeDirection
{
    case Left
    case Right
    case Down
    case Up
}

class GameScene : SKScene
{
    let HORIZ_SWIPE_DRAG_MIN : CGFloat = 12.0
    let VERT_SWIPE_DRAG_MAX : CGFloat = 4.0
    
    let megaman = MegamanNode()
    
    var startTouchPosition : CGPoint = CGPointZero
    
    override func didMoveToView( view: SKView )
    {
        addChild( megaman )
        
        megaman.position = CGPoint( x: frame.width / 2.0, y: frame.height / 2.0 )
        megaman.still()
    }
    
    override func update(currentTime: CFTimeInterval)
    {
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
    {
        let touch = touches.anyObject() as UITouch
        startTouchPosition = touch.locationInNode(self)
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
    {
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
    {
        for touch in ( touches.allObjects as UITouch[] )
        {
            if touch.tapCount > 0
            {
                switch touch.tapCount
                {
                    case 1:
                        handleSingleTap(touch)
                    case 2:
                        handleDoubleTap(touch)
                    case 3:
                        handleTripleTap(touch)
                    default:
                        handleMultipleTap(touch, tapCount: touch.tapCount)
                }
            }
            else
            {
                // TODO : Differentiate between swipe and panning
                
                let currentTouchPosition = touch.locationInNode(self)
                
                let touchVector = Vector3D(x: currentTouchPosition.x - startTouchPosition.x, y: currentTouchPosition.y - startTouchPosition.y, z: 0.0 )
                let horVector = Vector3D(x: 1.0, y: 0.0, z: 0.0)
                let angle = horVector.angleBetween(touchVector)
                
                if ( angle < 45 ) || ( angle > 135 )
                {
                    handleHorizontalSwipe( touch, direction: startTouchPosition.x < currentTouchPosition.x ? .Left : .Right )
                }
                else
                {
                    handleVerticalSwipe( touch, direction: startTouchPosition.y < currentTouchPosition.y ? .Down : .Up )
                }
                
                startTouchPosition = CGPointZero
            }
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)
    {
         startTouchPosition = CGPointZero
    }
    
    func handleSingleTap(touch: UITouch!)
    {
        handleShot(touch)
    }
    
    func handleDoubleTap(touch: UITouch!)
    {
        handleShot(touch)
    }
    
    func handleTripleTap(touch: UITouch!)
    {
        handleShot(touch)
    }
    
    func handleMultipleTap(touch: UITouch, tapCount: Int)
    {
        handleShot(touch)
    }
    
    func handleShot(touch: UITouch)
    {
        let location = touch.locationInNode(self)
        megaman.faceLocation(location)
        megaman.shoot()
    }
    
    func handleHorizontalSwipe(touch: UITouch!, direction: SwipeDirection)
    {
        let location = touch.locationInNode(self)
        megaman.faceLocation(location)
        megaman.moveTo( location )
    }
    
    func handleVerticalSwipe(touch: UITouch!, direction: SwipeDirection)
    {
    }
    
    func handlePanning(touch: UITouch!)
    {
    }
}











































