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

class GameScene : SKScene, JoystickViewDelegate
{
    let HORIZ_SWIPE_DRAG_MIN : CGFloat = 12.0
    let VERT_SWIPE_DRAG_MAX : CGFloat = 4.0
    
    let megaman = MegamanNode()
    
    var startTouchPosition : CGPoint = CGPointZero
    
    var currentDirection : JoystickDirection = .Unknown
    
    override func didMoveToView( view: SKView )
    {
        addChild( megaman )
        
        megaman.position = CGPoint( x: frame.width / 2.0, y: frame.height / 2.0 )
        megaman.still()
    }
    
    override func update(currentTime: CFTimeInterval)
    {
    }
    
    func joystickDirectionalButtonDidTap(direction: JoystickDirection) {
        print("-> \(direction.hashValue)")
        
        switch direction {
        case .Left:
            megaman.moveLeft()
        case .Right:
            megaman.moveRight()
        default:
            return
        }
    }
    
    func joystickStartMoving(direction: JoystickDirection) {
        if (direction != currentDirection) {
            currentDirection = direction
            var position = megaman.position
            position.x = currentDirection == .Left ? 0.0 : frame.size.width;
            megaman.moveTo(position);
        }
    }
    
    func joystickStopMoving() {
        currentDirection = .Unknown
        megaman.still()
    }
    
    func joystickAButtonDidTap() {
        //        megaman.shoot()
    }
    
    func joystickBButtonDidTap()  {
        megaman.jump()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            startTouchPosition = touch.locationInNode(self)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches
        {
            if touches.count > 0
            {
                switch touches.count
                {
                case 1:
                    handleSingleTap(touch)
                case 2:
                    handleDoubleTap(touch)
                case 3:
                    handleTripleTap(touch)
                default:
                    handleMultipleTap(touch, tapCount: touches.count)
                }
            }
            else
            {
                // TODO : Differentiate between swipe and panning
                if let touch = touches.first {
                    let currentTouchPosition = touch.locationInNode(self)
                    
                    let touchVector = Vector3D(currentTouchPosition.x - startTouchPosition.x, currentTouchPosition.y - startTouchPosition.y, 0.0 )
                    let horVector = Vector3D(1.0, 0.0, 0.0)
                    let angle = horVector.angleBetween(touchVector)
                    
                    if ( angle < 45 ) || ( angle > 135 )
                    {
                        handleHorizontalSwipe( touch, direction: startTouchPosition.x < currentTouchPosition.x ? .Left : .Right )
                    }
                    else
                    {
                        handleVerticalSwipe( touch, direction: startTouchPosition.y < currentTouchPosition.y ? .Up : .Down )
                    }
                    
                    startTouchPosition = CGPointZero
                }
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?)
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
        megaman.shoot(touch.locationInNode(self))
    }
    
    func handleHorizontalSwipe(touch: UITouch!, direction: SwipeDirection)
    {
        megaman.moveTo( touch.locationInNode(self) )
    }
    
    func handleVerticalSwipe(touch: UITouch!, direction: SwipeDirection)
    {
        if direction == .Up {
            megaman.jump()
        }
    }
    
    func handlePanning(touch: UITouch!)
    {
    }
}











































