//
//  TileMap.swift
//  2DTileMap
//
//  Created by Timothy Vermeersch on 1/29/20.
//  Copyright © 2020 Timothy Vermeersch. All rights reserved.
//
import Foundation
import CoreFoundation
import CoreGraphics
import SpriteKit

public class TileMap {
    private var mapFileName: String
    public var xCoordinate: Int
    public var yCoordinate: Int
    private var tileSide = 64
    private var frameHeight = 16
    private var frameWidth = 30
    private var tiles = Dictionary<Int,Tile>()
    private var currentNodes = [SKSpriteNode]()
    private var fileInformation = Dictionary<String, AnyObject>()
    public var forcedFraming = true
    public var customSideLength = false
    public var mapWidth = 100
    public var mapHeight = 100
    public var frameHeightPx = 1080
    public var frameWidthPx = 1920
    public init(mapFileName:String, x:Int = 15, y:Int = 15) {
        self.mapFileName = mapFileName
        xCoordinate = x
        yCoordinate = y
        fileInformation = readJSON(fileName: mapFileName)
    }
    
    public func getVisibleTiles(scene: SKScene){
        let layers = fileInformation["layers"] as? [Dictionary<String, AnyObject>]
        let layersData = layers![0]["data"] as? [Int]
        var mapLayerInfo:[Int]
        mapLayerInfo = []
        if(!customSideLength){
            tileSide = fileInformation["tileheight"] as! Int
            frameHeight = frameHeightPx/tileSide
            frameWidth = frameWidthPx/tileSide
        }
        mapWidth = fileInformation["width"] as! Int
        mapHeight = fileInformation["height"] as! Int
        var low = (frameHeight)/2
        let high = low
        low /= -1
        print(low)
        for y in low...high{
            let center = Int(mapWidth * (mapHeight - yCoordinate - y) + xCoordinate + 1)
            let left = center-(frameWidth/2)
            let right = center+(frameWidth/2)
            if(left<0 ){
                for i in 0...frameWidth{
                    mapLayerInfo.append(-1)
                }
            }else if(right>=mapWidth*mapHeight){
                for i in 0...frameWidth{
                    mapLayerInfo.insert(-1, at: 0)
                }
            }else{
                
                mapLayerInfo = layersData![left...right] + mapLayerInfo
            }
        }
        for node in currentNodes{
            node.removeFromParent()
        }
        currentNodes.removeAll()
        var tileX = -1 * frameWidthPx/2
        var tileY = -1 * frameHeightPx/2
        for tileKey in Set(mapLayerInfo){
            if(!tiles.keys.contains(tileKey)){
                tiles[tileKey] = Tile(textureName: String(tileKey))
            }
        }
        for tileKey in mapLayerInfo{
            let newTile = tiles[tileKey]
            newTile?.nodeValue.position.x = CGFloat(tileX)
            newTile?.nodeValue.position.y = CGFloat(tileY)
            currentNodes.insert((newTile?.nodeValue.copy() as? SKSpriteNode)!, at: 0)
            scene.addChild(currentNodes[0])
            tileX += tileSide
            if(tileX/tileSide >= frameWidth/2+1){
                tileX = -1 * frameWidthPx/2
                tileY += tileSide
            }
        }
    }
    
    private func readJSON(fileName: String) -> Dictionary<String, AnyObject>
    {
        //Checking to see if file exists
        if let path = Bundle.main.path(forResource: "TestMap", ofType: "json") {
            do {
				
				let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
				let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>{
                    return jsonResult
                }
              } catch {
                   // handle error
              }
        }
        return Dictionary<String, AnyObject>()
    }
    
    private func splitBetween(value: String, firstSep: String, secondSep: String) -> String{
        var valueCopy = value.components(separatedBy: firstSep)[1]
        valueCopy = valueCopy.components(separatedBy: secondSep)[0]
        return value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    public func setTileSideLength(length: Int){
        if(length<=0){
            print("Invalid Length Value: length must be greater then zero")
        }else{
            frameHeight = frameHeightPx/length
            frameWidth = frameWidthPx/length
            tileSide = length
        }
    }
    
    public func moveRight(){
        if(forcedFraming){
            if(xCoordinate + 1 + (frameWidth/2)<=mapWidth){
                xCoordinate += 1
            }
        }else{
            xCoordinate += 1
        }
    }
    
    public func moveLeft(){
        if(forcedFraming){
            if(xCoordinate - (frameWidth/2)>=0){
                xCoordinate -= 1
            }
        }else{
            xCoordinate -= 1
        }
    }
    
    public func moveUp(){
        if(forcedFraming){
            if((yCoordinate + 1 + (frameHeight)/2)<=mapHeight){
                yCoordinate += 1
            }
        }else{
            yCoordinate += 1
        }
    }
    
    public func moveDown(){
        if(forcedFraming){
            if((yCoordinate - 1 - (frameHeight)/2)>=0){
                yCoordinate -= 1
            }
        }else{
            yCoordinate -= 1
        }
    }
    

}


