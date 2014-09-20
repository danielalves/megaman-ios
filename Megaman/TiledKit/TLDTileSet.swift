//
//  TLDTileSet.swift
//  Megaman
//
//  Created by Daniel L. Alves on 9/6/14.
//  Copyright (c) 2014 Daniel L. Alves. All rights reserved.
//

import Foundation
import UIKit

class TLDTileSet : Printable
{
    enum JsonKey : String
    {
        case Name = "name"
        case FirstGID = "firstgid"
        case ImagePath = "image"
        case ImageWidth = "imagewidth"
        case ImageHeight = "imageheight"
        case Margin = "margin"
        case Spacing = "spacing"
        case TransparentColor = "transparentcolor"
        case TileWidth = "tilewidth"
        case TileHeight = "tileheight"
        case Properties = "properties"
    }
    
    var name = ""
    
    var imagePath = ""
    var imageWidth: UInt32 = 0
    var imageHeight: UInt32 = 0
    var margin: UInt16 = 0
    var spacing: UInt16 = 0
    var transparentColor = TLDColor()
    
    var tileWidth: UInt16 = 0
    var tileHeight: UInt16 = 0
    
    var firstTileIndex : TLDTileIndex = 0
    
    var properties: Dictionary<String, AnyObject> = [:]
    
    var lastTileIndex : TLDTileIndex
    {
        return TLDTileIndex( nHorizontalTiles * nVerticalTiles )
    }
    
    var nHorizontalTiles : UInt32
    {
        // margin << 1 => left/right or top/bottom margin
        // spacing => There is no spacing after the last column/row of tiles
        return ( imageWidth - UInt32(( margin << 1 ) + spacing) ) / UInt32( tileWidth + spacing )
    }
    
    var nVerticalTiles : UInt32
    {
        // margin << 1 => left/right or top/bottom margin
        // spacing => There is no spacing after the last column/row of tiles
        return ( imageHeight - UInt32(( margin << 1 ) + spacing) ) / UInt32( tileHeight + spacing )
    }

    var description: String
    {
        return "TileSet \"\(name)\" - " +
               "size: \(imageWidth)px x \(imageHeight)px; " +
               "path: \(imagePath); " +
               "tiles size: \(tileWidth)px x \(tileHeight)px; " +
               "spacing: \(spacing)px; " +
               "margin: \(margin)px; " +
               "first tile index: \(firstTileIndex);"
    }
    
    class func loadFromDictionary(dict: Dictionary<String, AnyObject>) -> TLDTileSet?
    {
        var tileSet = TLDTileSet()
        
        if let parsedName = dict[ JsonKey.Name.toRaw() ] as? NSString {
            tileSet.name = parsedName
        }
        
        if let parsedImagePath = dict[ JsonKey.ImagePath.toRaw() ] as? NSString {
            tileSet.imagePath = parsedImagePath.componentsSeparatedByString( "/" ).bridgeToObjectiveC().lastObject as NSString
        }

        if let parsedImageWidth = dict[ JsonKey.ImageWidth.toRaw() ] as? NSNumber {
            tileSet.imageWidth = UInt32( parsedImageWidth.unsignedIntValue )
        }
        
        if let parsedImageHeight = dict[ JsonKey.ImageHeight.toRaw() ] as? NSNumber {
            tileSet.imageHeight =  UInt32( parsedImageHeight.unsignedIntValue )
        }
        
        if let parsedMargin = dict[ JsonKey.Margin.toRaw() ] as? NSNumber {
            tileSet.margin = UInt16( parsedMargin.unsignedIntValue )
        }
        
        if let parsedSpacing = dict[ JsonKey.Spacing.toRaw() ] as? NSNumber {
            tileSet.spacing = UInt16( parsedSpacing.unsignedIntValue )
        }
        
        if let parsedTileWidth = dict[ JsonKey.TileWidth.toRaw() ] as? NSNumber {
            tileSet.tileWidth = UInt16( parsedTileWidth.unsignedIntValue )
        }
        
        if let parsedTileHeight = dict[ JsonKey.TileHeight.toRaw() ] as? NSNumber {
            tileSet.tileHeight =  UInt16( parsedTileHeight.unsignedIntValue )
        }
        
        if let parsedFirstTileIndex = dict[ JsonKey.FirstGID.toRaw() ] as? NSNumber {
            tileSet.firstTileIndex =  TLDTileIndex( parsedFirstTileIndex.shortValue )
        }
        
        return tileSet
    }
    
    func containsTileIndex( tileIndex: TLDTileIndex ) -> Bool
    {
        return tileIndex >= firstTileIndex && tileIndex <= lastTileIndex
    }
    
    func rectForTileIndex( tileIndex: TLDTileIndex ) -> CGRect?
    {
        if containsTileIndex( tileIndex ) {
            let zeroBasedIndex = tileIndex - firstTileIndex
            
            return CGRectMake( CGFloat( UInt32( margin ) + ( UInt32(zeroBasedIndex) % nHorizontalTiles ) * UInt32( tileWidth + spacing )),
                               CGFloat( UInt32( margin ) + ( UInt32(zeroBasedIndex) / nHorizontalTiles ) * UInt32( tileHeight + spacing )),
                               CGFloat( tileWidth ),
                               CGFloat( tileHeight ))
        }
        return nil
    }
    
    func unitRectForTileIndex( tileIndex: TLDTileIndex ) -> CGRect?
    {
        var optionalRect = rectForTileIndex( tileIndex )
        if var rect = optionalRect {
            rect.origin.x /= CGFloat( imageWidth )
            rect.origin.y = ( CGFloat( imageHeight ) - rect.origin.y - rect.size.height ) / CGFloat( imageHeight )
            
            rect.size.width /= CGFloat( imageWidth )
            rect.size.height /= CGFloat( imageHeight )
            
            return rect
        }
        return nil
    }
}















































