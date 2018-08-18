//
//  HexTextureGenerator.swift
//  floatios
//
//  Created by Alexander Skorulis on 3/8/18.
//  Copyright © 2018 Skorulis. All rights reserved.
//

import SKSwiftLib

public class HexTextureGenerator: ImageGen {

    public let math:Hex3DMath
    
    public init() {
        math = Hex3DMath(baseSize: 128)
        super.init(rootDir: "3d")
    }
    
    public func topHex(_ color:UIColor) -> UIImage {
        let ctx = newContext(textureSize)
        makeHexPath(ctx: ctx)
        ctx.setFillColor(color.cgColor)
        ctx.fillPath()
        
        makeHexPath(ctx: ctx)
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.strokePath()
        
        return finishContext(context:ctx)
    }
    
    public func topHex(_ texture:UIImage,lineColor:UIColor) -> UIImage {
        let ctx = newContext(textureSize)
        makeHexPath(ctx: ctx)
        ctx.clip()
        #if os(OSX)
        let priorNsgc = NSGraphicsContext.current
        defer { NSGraphicsContext.current = priorNsgc }
        NSGraphicsContext.current = NSGraphicsContext(cgContext: ctx, flipped: false)
        #endif
        
        texture.draw(in: CGRect(x: 0, y: 0, width: textureSize.width, height: textureSize.height))
        
        makeHexPath(ctx: ctx)
        ctx.setStrokeColor(lineColor.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.strokePath()
        
        return finishContext(context:ctx)
    }
    
    public func spikeySide(_ color:UIColor) -> UIImage {
        let ctx = newContext(textureSize)
        let spikeCount = 3
        let xMov = textureSize.width / CGFloat(spikeCount * 2)
        ctx.setFillColor(UIColor.lightGray.cgColor)
        ctx.fill(CGRect(origin: .zero, size: textureSize))
        
        let spikeTop = textureSize.height / 8
        let spikeBottom = textureSize.height / 3
        
        ctx.move(to: CGPoint(x: 0, y: spikeBottom))
        for i in 0...spikeCount {
            let p1 = CGPoint(x: xMov*2*CGFloat(i), y: spikeBottom)
            let p2 = CGPoint(x: xMov*(2*CGFloat(i) + 1), y: spikeTop)
            ctx.addLine(to: p1)
            ctx.addLine(to: p2)
        }
        ctx.addLine(to: CGPoint(x: textureSize.width, y: 0))
        ctx.addLine(to: CGPoint(x: 0, y: 0))
        ctx.closePath()
        ctx.setFillColor(color.cgColor)
        ctx.fillPath()
        
        ctx.move(to: .zero)
        ctx.addLine(to: CGPoint(x: textureSize.width, y: 0))
        ctx.setStrokeColor(UIColor.black.cgColor)
        ctx.setLineWidth(lineWidth)
        ctx.strokePath()
        
        return finishContext(context:ctx)
    }
    
    private func makeHexPath(ctx:CGContext) {
        let points = (0..<6).map { math.regularHexUV(index: $0)}
        ctx.move(to: points[0])
        for i in 1..<6 {
            ctx.addLine(to: points[i])
        }
        ctx.closePath()
    }
    
    public class func generateAllImages() {
        let gen = HexTextureGenerator()
        
        gen.saveImage(name: "hex1", image: gen.topHex(UIColor.brown))
        gen.saveImage(name: "spike1", image: gen.spikeySide(UIColor.brown))
        
        let texture = UIImage.sceneImage(named: "sandyground1_normal")!
        gen.saveImage(name: "texturedHex", image: gen.topHex(texture, lineColor: UIColor.brown))
    }
    
    //MARK: Helpers
    
    public var textureSize: CGSize {
        return CGSize(width: math.baseSize, height: math.baseSize)
    }
    
    private var lineWidth:CGFloat {
        return 4
    }
    
    
    
}
