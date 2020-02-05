import Foundation
import SpriteKit
import UIKit

public class Tile{
    private var specialProperties = [String]()
    public var nodeValue:SKSpriteNode
    public var solid = false
    public init(textureName:String) {
        nodeValue = SKSpriteNode(imageNamed: textureName)
    }
    
    public func addProperty(newProperty: String){
        specialProperties.append(newProperty)
    }
}

