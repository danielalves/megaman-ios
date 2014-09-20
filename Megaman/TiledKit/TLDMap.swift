//
//  TLDMap.swift
//  Megaman
//
//  Created by Daniel L. Alves on 9/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class TLDMap : Printable
{
    enum Orientation : String
    {
        case ORTHOGONAL = "orthogonal"
        case ISOMETRIC = "isometric"
        case STAGGERED = "staggered"
    }
    
    enum JsonKey : String
    {
        case Version = "version"
        case Orientation = "orientation"
        case Width = "width"
        case Height = "height"
        case TileWidth = "tilewidth"
        case TileHeight = "tileheight"
        case TileSets = "tilesets"
        case Properties = "properties"
        case Layers = "layers"
        case BackgroundColor = "backgroundcolor"
    }
    
    enum ErrorCode : Int
    {
        case NO_ERROR = 0
        case INVALID_JSON_OBJECT
        case INVALID_TILED_TILE_MAP_FORMAT
        case NO_ORIENTATION
    }
    
    // No class variables until XCode Beta 6.0 =/
    enum ErrorDomain : String
    {
        case Tiled = "TiledErrorDomain"
    }
    
    var version: String? = nil
    var orientation: Orientation = .ORTHOGONAL
    
    var backgroundColor: TLDColor? = nil
    var layers : TLDLayer[] = []
    var tileSets : TLDTileSet[] = []
    var tileSetTexture : SKTexture? = nil

    // The tilewidth and tileheight properties determine the general grid size of the map. The individual
    // tiles may have different sizes. Larger tiles will extend at the top and right (anchored to the 
    // bottom left).
    var tileWidth: UInt16 = 0
    var tileHeight: UInt16 = 0
    
    var width: UInt32 = 0
    var height: UInt32 = 0

    // TODO : Can contain: properties, tileset, layer, objectgroup, imagelayer
    // ...
    
    var description : String {
        return "TLDMap v\(version) \(width)tiles x \(height)tiles: tiles \(tileWidth)px x \(tileHeight)px"
    }
    
    class func loadFromJsonAtPath(path: String, error: NSErrorPointer = nil) -> TLDMap?
    {
        let mapData = NSData.dataWithContentsOfFile(path, options: NSDataReadingOptions.DataReadingUncached, error: error)
        if !mapData {
            return nil
        }
        
        let jsonObject = NSJSONSerialization.JSONObjectWithData(mapData, options: NSJSONReadingOptions.MutableContainers, error: error)
        if jsonObject == nil {
            return nil
        }

        if !NSJSONSerialization.isValidJSONObject( jsonObject ) {
            if error {
                error.memory = NSError.errorWithDomain( ErrorDomain.Tiled.toRaw(),
                                                        code: ErrorCode.INVALID_JSON_OBJECT.toRaw(),
                                                        userInfo: [ NSLocalizedDescriptionKey: "Invalid json" ])
            }
            return nil
        }
        
        var mapDict : Dictionary<String, AnyObject>
        if let parsedDict = jsonObject as? Dictionary<String, AnyObject> {
            mapDict = parsedDict
        }
        else {
            if error {
                error.memory = NSError.errorWithDomain( ErrorDomain.Tiled.toRaw(),
                               code: ErrorCode.INVALID_TILED_TILE_MAP_FORMAT.toRaw(),
                               userInfo: [ NSLocalizedDescriptionKey: "Invalid json: Expected dictionary at the top-most level" ])
            }
            return nil
        }

        let map = TLDMap()

        var hasOrientation = false
        if let orientationString = mapDict[ JsonKey.Orientation.toRaw() ] as? NSString {
            if let parsedOrientation = Orientation.fromRaw( orientationString ) {
                hasOrientation = true
                map.orientation = parsedOrientation
            }
        }
        
        if !hasOrientation {
            if error {
                error.memory = NSError.errorWithDomain( ErrorDomain.Tiled.toRaw(),
                                                        code: ErrorCode.NO_ORIENTATION.toRaw(),
                                                        userInfo: [ NSLocalizedDescriptionKey: "No orientation: All Tiled tile maps must have an orientation" ])
            }
            return nil
        }
        
        if let parsedVersion = mapDict[ JsonKey.Version.toRaw() ] as? NSNumber {
            map.version = parsedVersion.stringValue
        }
        
        if let parsedWidth = mapDict[ JsonKey.Width.toRaw() ] as? NSNumber {
            map.width = UInt32( parsedWidth.unsignedIntValue )
        }
        
        if let parsedHeight = mapDict[ JsonKey.Height.toRaw() ] as? NSNumber {
            map.height = UInt32( parsedHeight.unsignedIntValue )
        }
        
        if let parsedTileWidth = mapDict[ JsonKey.TileWidth.toRaw() ] as? NSNumber {
            map.tileWidth = UInt16( parsedTileWidth.unsignedIntValue )
        }
        
        if let parsedTileHeight = mapDict[ JsonKey.TileHeight.toRaw() ] as? NSNumber {
            map.tileHeight =  UInt16( parsedTileHeight.unsignedIntValue )
        }
        
        var tempSinceXCodeIsNotBeingAbleToParseWhenInsideIfLetExpression = mapDict[ JsonKey.Layers.toRaw() ]
        if let layerDicts = tempSinceXCodeIsNotBeingAbleToParseWhenInsideIfLetExpression as? Dictionary<String, AnyObject>[] {
            for layerDict in layerDicts {
                if let parsedLayer = TLDLayer.loadFromDictionary( layerDict ) {
                    map.layers.append( parsedLayer )
                }
            }
        }

        tempSinceXCodeIsNotBeingAbleToParseWhenInsideIfLetExpression = mapDict[ JsonKey.TileSets.toRaw() ]
        if let tileSetDicts = tempSinceXCodeIsNotBeingAbleToParseWhenInsideIfLetExpression as? Dictionary<String, AnyObject>[] {
            for tileSetDict in tileSetDicts {
                if let parsedTileSet = TLDTileSet.loadFromDictionary( tileSetDict ) {
                    map.tileSets.append( parsedTileSet )
                }
            }
        }
        
        return map
    }
    
    func toSpriteKitNodes() -> SKNode[]
    {
        var layerNodes: SKNode[] = []
        
        if !tileSets.isEmpty
        {
            let mainTileSet = tileSets[0]
            tileSetTexture = SKTexture(imageNamed: mainTileSet.imagePath)
            
            for layer in layers
            {
                let layerNode = SKNode()
                let layerHeightInPixels = CGFloat( layer.height * UInt32( mainTileSet.tileHeight ))
                
                for (index, tileIndex) in enumerate( layer.tileIndexes )
                {
                    if let tileImageRect = mainTileSet.unitRectForTileIndex( tileIndex )
                    {
                        let croppedTexture = SKTexture(rect: tileImageRect, inTexture: tileSetTexture)
                        
                        let tileNode = SKSpriteNode(texture: croppedTexture)
                        layerNode.addChild( tileNode )
                        
                        if layer.collision {
                            tileNode.physicsBody = SKPhysicsBody(edgeLoopFromRect: tileNode.frame)
                        }

                        let x = ( UInt32(index) % layer.width ) * UInt32(mainTileSet.tileWidth)
                        let y = ( UInt32(index) / layer.width ) * UInt32(mainTileSet.tileHeight)

                        tileNode.position = CGPointMake( CGFloat(x) + tileImageRect.size.width / 2.0 ,
                                                         layerHeightInPixels - CGFloat(y) + tileImageRect.size.height / 2.0 )
                    }
                }
                
                if !layerNode.children.isEmpty
                {
                    layerNodes += layerNode
                }
            }
        }
        
        return layerNodes
    }
}











































