//
//  TLDLayer.swift
//  Megaman
//
//  Created by Daniel L. Alves on 9/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import Foundation
import UIKit

class TLDLayer : Printable
{
    enum LayerType : String
    {
        case TileLayer = "tilelayer"
    }
    
    enum JsonKey : String
    {
        case Name = "name"
        case LayerType = "type"
        case Tiles = "data"
        case OffsetX = "x"
        case OffsetY = "y"
        case Width = "width"
        case Height = "height"
        case Opacity = "opacity"
        case Visible = "visible"
    }
    
    var name: String = ""
    var layerType: LayerType = .TileLayer
    
    var tileIndexes: TLDTileIndex[] = []

    var offsetX: UInt32 = 0
    var offsetY: UInt32 = 0
    var width: UInt32 = 0
    var height: UInt32 = 0
    
    var opacity: CGFloat = 1.0
    var visible: Bool = true
    
    var description: String {
        return  NSString( format: "TLDLayer \"\(name)\" - " +
                                  "size: \(width)tiles x \(height)tiles; " +
                                  "offset: (\(offsetX), \(offsetY))tiles; " +
                                  "visibility: %@; " +
                                  "opacity: %.3f;",
                                  visible ? "visible" : "hidden",
                                  opacity )
    }
    
    class func loadFromDictionary(dict: Dictionary<String, AnyObject>) -> TLDLayer?
    {
        var tileLayer = TLDLayer()
        
        if let parsedName = dict[ JsonKey.Name.toRaw() ] as? NSString {
            tileLayer.name = parsedName
        }
        
        if let parsedLayerTypeString = dict[ JsonKey.LayerType.toRaw() ] as? NSString {
            if let layerType = LayerType.fromRaw(parsedLayerTypeString) {
                tileLayer.layerType = layerType
            }
        }

        if let parsedTilesArray =  dict[ JsonKey.Tiles.toRaw() ] as? NSArray {
            for index in parsedTilesArray {
                let castedIndex = index as NSNumber
                tileLayer.tileIndexes.append( TLDTileIndex( castedIndex.shortValue ) )
            }
        }

        if let parsedOffsetX = dict[ JsonKey.OffsetX.toRaw() ] as? NSNumber {
            tileLayer.offsetX = UInt32( parsedOffsetX.unsignedIntValue )
        }
        
        if let parsedOffsetY = dict[ JsonKey.OffsetY.toRaw() ] as? NSNumber {
            tileLayer.offsetY =  UInt32( parsedOffsetY.unsignedIntValue )
        }
        
        if let parsedWidth = dict[ JsonKey.Width.toRaw() ] as? NSNumber {
            tileLayer.width = UInt32( parsedWidth.unsignedIntValue )
        }
        
        if let parsedHeight = dict[ JsonKey.Height.toRaw() ] as? NSNumber {
            tileLayer.height = UInt32( parsedHeight.unsignedIntValue )
        }
        
        if let parsedOpacity = dict[ JsonKey.Opacity.toRaw() ] as? NSNumber {
            tileLayer.opacity = CGFloat( parsedOpacity.floatValue )
        }
        
        if let parsedVisibility = dict[ JsonKey.Visible.toRaw() ] as? NSNumber {
            tileLayer.visible =  parsedVisibility.boolValue
        }
        
        return tileLayer
    }
}
