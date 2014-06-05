//
//  Vector3D.swift
//  Megaman
//
//  Created by Daniel L. Alves on 4/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import Foundation
import UIKit

struct Vector3D
{
    var x : CGFloat = 0.0
    var y : CGFloat = 0.0
    var z : CGFloat = 0.0
    
    init(x: CGFloat, y: CGFloat, z: CGFloat)
    {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(point: CGPoint)
    {
        self.x = point.x
        self.y = point.y
        self.z = 0.0
    }
    
    init(other: Vector3D)
    {
        self.x = other.x
        self.y = other.y
        self.z = other.z
    }
    
    func module() -> CGFloat
    {
        return sqrtf( x*x + y*y + z*z )
    }
    
    func dot(other: Vector3D) -> CGFloat
    {
        return x * other.x + y * other.y + z * other.z
    }
    
    func cross(other: Vector3D) -> Vector3D
    {
        return Vector3D( x: y * other.z - z * other.y,
                         y: z * other.x - x * other.z,
                         z: x * other.y - y * other.x )
    }
    
    func angleBetween(other: Vector3D) -> CGFloat
    {
        return radiansToDegrees( acosf( normalized().dot( other.normalized() ) ) )
    }
    
    mutating func normalize() -> Vector3D
    {
        var m = module()
        if( fdif( m, 0.0 ) )
        {
            x /= m
            y /= m
            z /= m
        }
        return self
    }
    
    func normalized() -> Vector3D
    {
        var clone = self
        return clone.normalize()
    }
}
