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
    func joystickDirectionalButtonDidTap(JoystickDirection)
    func joystickAButtonDidTap()
    func joystickBButtonDidTap()
}

class JoystickView: UIView {

    @IBOutlet var upDirectionButton : UIButton
    @IBOutlet var rightDirectionButton : UIButton
    @IBOutlet var leftDirectionButton : UIButton
    @IBOutlet var downDirectionButton : UIButton
    
    var delegate : JoystickViewDelegate?
    
    init(coder aDecoder: NSCoder!) {
        return super.init(coder: aDecoder)
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
}
