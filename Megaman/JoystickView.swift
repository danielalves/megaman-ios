//
//  JoystickView.swift
//  Megaman
//
//  Created by Gustavo Barbosa on 6/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import UIKit

enum JoystickDirection {
    case Up
    case Right
    case Down
    case Left
    case Unknown
}

protocol JoystickViewDelegate {
    func joystickDirectionalButtonDidTap(_: JoystickDirection)
    func joystickAButtonDidTap()
    func joystickBButtonDidTap()
    func joystickStartMoving(_: JoystickDirection)
    func joystickStopMoving()
}

class JoystickView: UIView {
    
    @IBOutlet var upDirectionButton : UIButton!
    @IBOutlet var rightDirectionButton : UIButton!
    @IBOutlet var leftDirectionButton : UIButton!
    @IBOutlet var downDirectionButton : UIButton!
    
    @IBOutlet var analogStickAreaView : UIView!
    @IBOutlet var analogStickView : UIView!
    
    var analogStickInitialized = false
    
    var startTouchPosition : CGPoint = CGPointZero
    
    var delegate : JoystickViewDelegate?
    
    func initializeAnalogStick() {
        analogStickAreaView.layer.borderColor = UIColor(white: 0.5, alpha: 0.8).CGColor
        analogStickAreaView.layer.borderWidth = 2.0
        analogStickAreaView.layer.cornerRadius = CGFloat(floorf(Float(analogStickAreaView.frame.size.height / 2.0)))
        
        analogStickView.layer.borderColor = UIColor(white: 0.3, alpha: 0.8).CGColor
        analogStickView.layer.borderWidth = 1.0
        analogStickView.layer.cornerRadius = CGFloat(floorf(Float(analogStickView.frame.size.height / 2.0)))
        
        analogStickView.layer.shadowColor = UIColor.blackColor().CGColor
        analogStickView.layer.shadowRadius = 10.0
        analogStickView.layer.shadowOffset = CGSizeMake(1, 1);
        
        analogStickInitialized = true
    }
    
    func showAnalogStick() {
        analogStickAreaView.hidden = false
        analogStickAreaView.center = startTouchPosition
        analogStickView.hidden = false
        analogStickView.center = startTouchPosition
    }
    
    func moveAnalogStick(position: CGPoint) {
        let radius = CGFloat(floorf(Float(analogStickAreaView.frame.size.height / 2.0)))
        var analogStickRelativePositionVector = Vector3D(position.x - analogStickAreaView.center.x, position.y - analogStickAreaView.center.y, 0.0)
        
        if analogStickRelativePositionVector.module <= radius {
            analogStickView.center = position
        } else {
            analogStickRelativePositionVector.normalize()
            let x = analogStickAreaView.center.x + analogStickRelativePositionVector.x * radius
            let y = analogStickAreaView.center.y + analogStickRelativePositionVector.y * radius
            
            analogStickView.center = CGPointMake(x, y)
        }
    }
    
    @IBAction func directionButtonDidTap(sender : UIButton) {
        var direction : JoystickDirection
        
        switch sender {
        case upDirectionButton:
            direction = .Up
        case rightDirectionButton:
            direction = .Right
        case downDirectionButton:
            direction = .Down
        case leftDirectionButton:
            direction = .Left
        default:
            direction = .Unknown
        }
        
        delegate?.joystickDirectionalButtonDidTap(direction)
    }
    
    @IBAction func aButtonDidTap() {
        delegate?.joystickAButtonDidTap()
    }
    
    @IBAction func bButtonDidTap() {
        delegate?.joystickBButtonDidTap()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            startTouchPosition = touch.locationInView(self)
            if !analogStickInitialized {
                initializeAnalogStick()
            }
            showAnalogStick()
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch =  touches.first {
            let currentTouchPosition = touch.locationInView(self)
            
            moveAnalogStick(currentTouchPosition)
            
            let touchVector = Vector3D(currentTouchPosition.x - startTouchPosition.x, currentTouchPosition.y - startTouchPosition.y, 0.0 )
            switch touchVector.x {
            case 0:
                delegate?.joystickStopMoving()
            case let x where x > 0:
                delegate?.joystickStartMoving(.Right)
            default:
                delegate?.joystickStartMoving(.Left)
            }
        }
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        analogStickAreaView.hidden = true
        analogStickView.hidden = true
        delegate?.joystickStopMoving()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?)  {
        analogStickAreaView.hidden = true
        analogStickView.hidden = true
        delegate?.joystickStopMoving()
    }
}
