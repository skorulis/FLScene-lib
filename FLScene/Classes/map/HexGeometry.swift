//
//  HexGeometry.swift
//  Hex3D
//
//  Created by Alexander Skorulis on 1/8/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SceneKit
import FLGame
import SKSwiftLib

public class MeshSetup {
    
    var meshVertices:[SCNVector3] = []
    var uvPoints:[CGPoint] = []
    var meshNormals:[SCNVector3] = []
    var indices:[UInt8] = []
    
    func toGeometry() -> SCNGeometry {
        let vertexSource = SCNGeometrySource(vertices: meshVertices)
        let normalSource = SCNGeometrySource(normals: meshNormals)
        let uvSource = SCNGeometrySource(textureCoordinates: uvPoints)
        
        let element = SCNGeometryElement(indices: indices, primitiveType: .triangles)
        let geometry = SCNGeometry(sources: [vertexSource,normalSource,uvSource], elements: [element])
        
        return geometry
    }
    
}

public class HexGeometry: NSObject {

    public let math = Hex3DMath(baseSize: 1)
    public let store:GeometryStore
    public let imageGen:HexTextureGenerator
    
    public init(store:GeometryStore) {
        self.store = store
        self.imageGen = HexTextureGenerator()
    }
    
    public func hexGeometry(ref:TerrainReferenceModel) -> SCNGeometry {
        let name = "hex-\(ref.type.rawValue)"
        return store.getGeometry(name: name, block: {return createGeometry(ref: ref)})
    }
    
    public func sideGeometry(height:CGFloat,ref:TerrainReferenceModel) -> SCNGeometry {
        let name = "hex-sides-\(height)-\(ref.type.rawValue)"
        return store.getGeometry(name: name, block: {return createSides(height: height,ref: ref)})
    }
    
    public func bevelHex(ref:TerrainReferenceModel) -> SCNGeometry {
        let name = "hex-bevel-\(ref.type.rawValue)"
        return store.getGeometry(name: name, block: {return createBevelHex(ref:ref)})
    }
    
    private func createGeometry(ref:TerrainReferenceModel) -> SCNGeometry {
        let normalUp = SCNVector3(0,1,0);
        let normalDown = SCNVector3(0,-1,0);
        
        let setup = MeshSetup()
        
        for i in 0..<6 {
            setup.meshVertices.insert(self.topPosition(self.math.regularHexPoint(index:i)), at: i)
            setup.meshVertices.insert(self.botPosition(self.math.regularHexPoint(index:i)), at: setup.meshVertices.count)
            
            setup.uvPoints.insert(self.math.regularHexUV(index: i), at: i)
            setup.uvPoints.insert(self.math.regularHexUV(index: i), at: setup.uvPoints.count)
            
            setup.meshNormals.insert(normalUp, at: i)
            setup.meshNormals.insert(normalDown, at: setup.meshNormals.count)
        }
        
        setup.indices = [2,1,0,  5,2,0,  5,3,2,  4,3,5]
        let bottomHex = setup.indices.reversed().map { $0 + 6}
        setup.indices.append(contentsOf: bottomHex)

        let geometry = setup.toGeometry()
        let material = MaterialProvider.topMaterial(ref: ref)
        
        geometry.firstMaterial = material
        
        return geometry
    }
    
    private func createBevelHex(ref:TerrainReferenceModel) -> SCNGeometry {
        let normalUp = SCNVector3(0,1,0);
        
        let middlePoint = CGPoint(x:0,y:0)
        let middleUV = CGPoint(x: 0.5, y: 0.5)
        let bevelAmount:CGFloat = 0.1
        
        var outerVertices:[SCNVector3] = []
        var outerUV:[CGPoint] = []
        
        let setup = MeshSetup()
        
        //Make centre hex
        for i in 0..<6 {
            let pOuter = self.math.regularHexPoint(index:i)
            let uvOuter = self.math.regularHexUV(index: i)
            
            let pTop = pOuter.mixed(with: middlePoint, ratio: bevelAmount)
            let uvTop = uvOuter.mixed(with: middleUV, ratio: bevelAmount)
            
            setup.meshVertices.insert(self.topPosition(pTop) + SCNVector3(0,bevelAmount,0), at: i)
            setup.uvPoints.insert(uvTop, at: i)
            setup.meshNormals.insert(normalUp, at: i)
            
            outerVertices.append(topPosition(pOuter))
            outerUV.append(uvOuter)
        }
        
        setup.indices = [2,1,0,  5,2,0,  5,3,2,  4,3,5]
        
        for i in 0...6 {
            let i2 = (i+1)%6
            
            let v1 = setup.meshVertices[i%6]
            let v2 = setup.meshVertices[i2]
            let v3 = outerVertices[i%6]
            let v4 = outerVertices[i2]
            
            let uv1 = setup.uvPoints[i%6]
            let uv2 = setup.uvPoints[i2]
            let uv3 = outerUV[i%6]
            let uv4 = outerUV[i2]
            
            let i1 = UInt8(setup.meshVertices.count)
            
            let normal = self.faceNormal(v1:v1,v2:v2).mixed(with: SCNVector3(0,1,0), ratio: 0.5)
            setup.meshVertices.append(contentsOf: [v1,v2,v3,v4])
            setup.meshNormals.append(contentsOf: [normal,normal,normal,normal])
            
            setup.uvPoints.append(contentsOf: [uv1,uv2,uv3,uv4])
            
            let faceIndices = [i1, i1+1, i1+3, i1+3, i1+2, i1]
            setup.indices.append(contentsOf: faceIndices)
        }
        
        let geometry = setup.toGeometry()
        
        let material = MaterialProvider.topMaterial(ref: ref)
        
        geometry.firstMaterial = material
        
        return geometry
    }
    
    private func createSides(height:CGFloat,ref:TerrainReferenceModel) -> SCNGeometry {
        let setup = MeshSetup()
        
        for i in 0...6 {
            let i2 = (i+1)%6
            
            let v1 = self.vertexPosition(self.math.regularHexPoint(index:i),y:height/2)
            let v2 = self.vertexPosition(self.math.regularHexPoint(index:i2),y:height/2)
            let v3 = self.vertexPosition(self.math.regularHexPoint(index:i),y:-height/2)
            let v4 = self.vertexPosition(self.math.regularHexPoint(index:i2),y:-height/2)
            
            let i1 = UInt8(setup.meshVertices.count)
            
            let normal = self.faceNormal(v1:v1,v2:v2)
            setup.meshVertices.append(contentsOf: [v1,v2,v3,v4])
            setup.meshNormals.append(contentsOf: [normal,normal,normal,normal])
            
            setup.uvPoints.append(contentsOf: [CGPoint(x: 0, y: 0),CGPoint(x: 1, y: 0),CGPoint(x: 0, y: 1),CGPoint(x: 1, y: 1)])
            
            let faceIndices = [i1, i1+1, i1+3, i1+3, i1+2, i1]
            setup.indices.append(contentsOf: faceIndices)
        }
        
        let geometry = setup.toGeometry()
        
        let material = MaterialProvider.sideMaterial(ref: ref)
        
        geometry.firstMaterial = material
        
        return geometry
    }
    
    public func height() -> CGFloat {
        let p1 = math.regularHexPoint(index: 0)
        let p2 = math.regularHexPoint(index: 1)
        let v1 = SCNVector3(p1.x,0,p1.y)
        let v2 = SCNVector3(p2.x,0,p2.y)
        return CGFloat((v2 - v1).magnitude())
    }
    
    private func topPosition(_ point:CGPoint) -> SCNVector3 {
        return vertexPosition(point,y: height()/2)
    }
    
    private func botPosition(_ point:CGPoint) -> SCNVector3 {
        return vertexPosition(point,y: -height()/2)
    }
    
    private func vertexPosition(_ point:CGPoint,y:CGFloat) -> SCNVector3 {
        return SCNVector3(point.x, y, point.y)
    }
    
    private func faceNormal(v1:SCNVector3,v2:SCNVector3) -> SCNVector3 {
        var dir = (v1 + v2)/2 - SCNVector3()
        dir.y = 0
        return dir.normalized()
    }
    
}
