//
//  Vector3D.swift
//  Megaman
//
//  Created by Daniel L. Alves on 4/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import UIKit

struct Vector3D : Printable, Equatable
{
    var x : CGFloat = 0.0
    var y : CGFloat = 0.0
    var z : CGFloat = 0.0
    
    var module : CGFloat
    {
        return sqrtf( x*x + y*y + z*z )
    }
    
    init(_ x: CGFloat, _ y: CGFloat, _ z: CGFloat)
    {
        self.x = x
        self.y = y
        self.z = z
    }
    
    init(point: CGPoint)
    {
        x = point.x
        y = point.y
        z = 0.0
    }
    
    init(cgVector: CGVector)
    {
        x = cgVector.dx
        y = cgVector.dy
        z = 0.0
    }
    
    init(other: Vector3D)
    {
        x = other.x
        y = other.y
        z = other.z
    }
    
    func dot(other: Vector3D) -> CGFloat
    {
        return x * other.x + y * other.y + z * other.z
    }
    
    func cross(other: Vector3D) -> Vector3D
    {
        return Vector3D( y * other.z - z * other.y,
                         z * other.x - x * other.z,
                         x * other.y - y * other.x )
    }
    
    func angleBetween(other: Vector3D) -> CGFloat
    {
        return radiansToDegrees( acosf( normalized().dot( other.normalized() ) ) )
    }
    
    mutating func normalize() -> Vector3D
    {
        let m = module
        if fdif( m, 0.0 )
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
    
    func toCGPoint() -> CGPoint
    {
        return CGPoint( x: x, y: y )
    }
    
    func toCGVector() -> CGVector
    {
        return CGVector( dx: x, dy: y )
    }
    
    subscript(index: Int) -> CGFloat
    {
        get
        {
            assert( index >= 0 && index < 3, "index must be positive and less than 3" )
            
            switch index
            {
                case 0:
                    return x
                case 1:
                    return y
                case 2:
                    return z
                
                // Will never run: assert is protecting us
                default:
                    return CGFloat.NaN;
            }
        }

        set(newValue)
        {
            assert( index >= 0 && index < 3, "index must be positive and less than 3" )
            
            switch index
            {
                case 0:
                    x = newValue
                case 1:
                    y = newValue
                case 2:
                    z = newValue
                
                // Will never run: assert is protecting us
                default:
                    return;
            }
        }
    }
    
    var description: String
    {
        return "x: \(x), y: \(y), z: \(z)"
    }
}

@infix func + (left: Vector3D, right: Vector3D) -> Vector3D
{
    return Vector3D( left.x + right.x, left.y + right.y, left.z + right.z )
}

@infix func - (left: Vector3D, right: Vector3D) -> Vector3D
{
    return Vector3D( left.x - right.x, left.y - right.y, left.z - right.z )
}

@prefix func - (vector: Vector3D) -> Vector3D
{
    return Vector3D( -vector.x, -vector.y, -vector.z )
}

@assignment func += (inout left: Vector3D, right: Vector3D)
{
    left = left + right
}

@assignment func -= (inout left: Vector3D, right: Vector3D)
{
    left = left - right
}

@prefix @assignment func ++ (inout vector: Vector3D) -> Vector3D
{
    vector += Vector3D(1.0, 1.0, 1.0)
    return vector
}

@infix func == (left: Vector3D, right: Vector3D) -> Bool
{
    return ( left.x == right.x ) && ( left.y == right.y ) && ( left.z == right.z )
}

@infix func * (left: Vector3D, right: CGFloat) -> Vector3D
{
    return Vector3D( left.x * right, left.y * right, left.z  * right )
}

@infix func * (left: CGFloat, right: Vector3D) -> Vector3D
{
    return right * left
}

@infix func * (left: Vector3D, right: Vector3D) -> CGFloat
{
    return left.dot( right )
}

operator infix ** {}

@infix func ** (left: Vector3D, right: Vector3D) -> Vector3D
{
    return left.cross( right )
}




























































