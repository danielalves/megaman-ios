//
//  GameScene.swift
//  Megaman
//
//  Created by Daniel L. Alves on 3/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import SpriteKit

enum SwipeDirection : Int
{
    case Left
    case Right
    case Down
    case Up
}

class GameScene : SKScene
{
    var megaman = MegamanNode()
    
    var startTouchPosition : CGPoint = CGPointZero
    
    let HORIZ_SWIPE_DRAG_MIN : CGFloat = 12.0
    let VERT_SWIPE_DRAG_MAX : CGFloat = 4.0
    
    override func didMoveToView( view: SKView )
    {
        self.addChild( megaman )
        
        megaman.position = CGPoint( x: self.frame.width / 2.0, y: self.frame.height / 2.0 )
        megaman.still()
    }
    
    override func update(currentTime: CFTimeInterval)
    {
    }
    
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!)
    {
        var touch = touches.anyObject() as UITouch
        self.startTouchPosition = touch.locationInNode(self)
    }
    
    override func touchesMoved(touches: NSSet!, withEvent event: UIEvent!)
    {
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!)
    {
        // OBS: for-in statement is breaking XCode 6 Beta =S
        var touchesArray : UITouch[] = touches.allObjects as UITouch[]
        var nTouches = touchesArray.count
        for( var i=0 ; i < nTouches ; ++i )
        {
            var touch = touchesArray[i]
            if( touch.tapCount > 0 )
            {
                switch( touch.tapCount )
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
                var touch = touches.anyObject() as UITouch
                var currentTouchPosition = touch.locationInNode(self)
                
                var touchVector = Vector3D(x: currentTouchPosition.x - self.startTouchPosition.x, y: currentTouchPosition.y - self.startTouchPosition.y, z: 0.0 )
                var horVector = Vector3D(x: 1.0, y: 0.0, z: 0.0)
                var angle = horVector.angleBetween(touchVector)
                
                if( angle < 45 || angle > 135 )
                {
                    handleHorizontalSwipe( touch, direction: self.startTouchPosition.x < currentTouchPosition.x ? .Left : .Right )
                }
                else
                {
                    handleVerticalSwipe( touch, direction: self.startTouchPosition.y < currentTouchPosition.y ? .Up : .Down )
                }
                
                self.startTouchPosition = CGPointZero
            }
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!)
    {
         self.startTouchPosition = CGPointZero
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
        var location = touch.locationInNode(self)
        megaman.faceLocation(location)
        megaman.shoot()
    }
    
    func handleHorizontalSwipe(touch: UITouch!, direction: SwipeDirection)
    {
        var location = touch.locationInNode(self)
        megaman.faceLocation(location)
        megaman.moveTo( location )
    }
    
    func handleVerticalSwipe(touch: UITouch!, direction: SwipeDirection)
    {
        if direction == .Up {
            megaman.jump()
        }
    }
    
    func handlePanning(touch: UITouch!)
    {
        // TODO
    }
}











































