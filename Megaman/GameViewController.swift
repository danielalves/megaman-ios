//
//  GameViewController.swift
//  Megaman
//
//  Created by Daniel L. Alves on 3/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode
{
    class func unarchiveFromFile(file : NSString) -> SKNode?
    {
        let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks")
        
        let sceneData = NSData.dataWithContentsOfFile(path, options: .DataReadingMappedIfSafe, error: nil)
        let archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
        
        archiver.setClass(classForKeyedUnarchiver(), forClassName: "SKScene")
        let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
        archiver.finishDecoding()
        return scene
    }
}

class GameViewController: UIViewController
{
    
    @IBOutlet var joystickView : JoystickView
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene
        {
            let skView = view as SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            // Sprite Kit applies additional optimizations to improve rendering performance
            skView.ignoresSiblingOrder = true
            
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .AspectFill
            
            joystickView.delegate = scene
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool
    {
        return true
    }

    override func supportedInterfaceOrientations() -> Int
    {
        return Int(UIInterfaceOrientationMask.Landscape.toRaw())
    }
}
