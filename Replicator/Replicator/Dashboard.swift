//
//  Dashboard.swift
//  Replicator
//
//  Created by joey on 11/4/19.
//  Copyright © 2019 TGI Technology. All rights reserved.
//

import UIKit

class Dashboard: UIView {

    var textLayers:[CATextLayer] = []

    var itemCount: Int = 24 {
        didSet {
            updateTextLayers(count: itemCount)
            commonInit()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        itemCount = 24
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        itemCount = 24
        commonInit()
    }

}

// MARK: -
fileprivate extension Dashboard {

    /// Better to set itemCount property rather than fire the function directly
    /// - Parameter count: count of textLayer elements
    func updateTextLayers(count: Int) {
        textLayers.removeAll()
        for _ in 1...count {
            let textLayer = CATextLayer()
            textLayers.append(textLayer)
        }
    }

    func commonInit() {
        drawDashes(onView: self, count: itemCount)
        drawText(onView: self, withTextLayers: textLayers)
    }

}

// MARK: - Drawing

/// Draw short and long dashes on a view
/// - Parameters:
///   - view: UIView
///   - count: number of dashes
fileprivate func drawDashes(onView view: UIView, count: Int) {
    // draw long lines
    var count: Int = count
    let replicatorLayer1 = CAReplicatorLayer()
    replicatorLayer1.frame = view.bounds

    replicatorLayer1.instanceCount = count
    replicatorLayer1.instanceDelay = CFTimeInterval(1 / count)
    replicatorLayer1.preservesDepth = false
    replicatorLayer1.instanceColor = UIColor.white.cgColor

    var angle = CGFloat.pi * 2.0 / CGFloat(count)
    replicatorLayer1.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
    view.layer.addSublayer(replicatorLayer1)

    let longLine = CALayer()
    let layerWidth: CGFloat = 3.0
    let layerHeight: CGFloat = 80
    let midX = view.bounds.midX - layerWidth / 2.0

    longLine.frame = CGRect(x: midX, y: 0.0, width: layerWidth, height: layerHeight)
    longLine.backgroundColor = UIColor.white.cgColor
    replicatorLayer1.addSublayer(longLine)

    // draw short lines
    let replicatorLayer2 = CAReplicatorLayer()
    replicatorLayer2.frame = view.bounds

    count = count * 2
    replicatorLayer2.instanceCount = count
    replicatorLayer2.instanceDelay = CFTimeInterval(1 / count)
    replicatorLayer2.preservesDepth = false
    replicatorLayer2.instanceColor = UIColor.white.cgColor

    angle = CGFloat.pi * 2.0 / CGFloat(count)
    replicatorLayer2.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
    view.layer.addSublayer(replicatorLayer2)

    let shortLine = CALayer()

    shortLine.frame = CGRect(x: midX, y: layerHeight/4, width: layerWidth, height: layerHeight/2)
    shortLine.backgroundColor = UIColor.white.cgColor
    replicatorLayer2.addSublayer(shortLine)
}


/// Draw numbers on a view
/// - Parameters:
///   - view: UIView
///   - textLayers: An array of CATextLayer, equal to dashes
fileprivate func drawText(onView view: UIView, withTextLayers textLayers: [CATextLayer]) {
    for layer in view.layer.sublayers ?? [] where layer is CATextLayer {
        layer.removeFromSuperlayer()
    }

    let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    let offset: CGFloat = 110.0

    for (index, textLayer) in textLayers.enumerated() {

        textLayer.fontSize = 26
        textLayer.string = "\(index * 10)"
        textLayer.alignmentMode = .center

        let angle: CGFloat = CGFloat(index) * (CGFloat.pi * 2.0 / CGFloat(textLayers.count))
        let calculatedOrigin = calculateOrigin(center: center, angle: angle, radius: view.bounds.width/2 - offset)
        let textSize = calculateTextSize(text: "\(index * 10)", font: UIFont.systemFont(ofSize: 26))
        let layerX: CGFloat = calculatedOrigin.x - textSize.width/2
        let layerY: CGFloat = calculatedOrigin.y - textSize.height/2
        textLayer.frame = CGRect(x: layerX, y: layerY, width: textSize.width, height: textSize.height)

        let degrees: CGFloat = (CGFloat(360.0) / CGFloat(textLayers.count)) * CGFloat(index) + 90.0
        let radians = CGFloat(degrees * CGFloat.pi / 180)
        textLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        textLayer.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)

        view.layer.addSublayer(textLayer)
    }
}

// MARK: - Helpers
fileprivate func drawCenterPoint(forView view: UIView) {
    let centerPoint = CALayer()

    let width: CGFloat = 10.0
    let height: CGFloat = 10.0

    centerPoint.frame = CGRect(x: view.bounds.midX - width/2, y: view.bounds.midY - height/2, width: width, height: height)
    centerPoint.cornerRadius = width/2
    centerPoint.backgroundColor = UIColor.white.cgColor
    view.layer.addSublayer(centerPoint)
}

fileprivate func calculateOrigin(center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
    let x = Float(radius) * cosf(Float(angle))
    let y = Float(radius) * sinf(Float(angle))

    return CGPoint(x: center.x + CGFloat(x), y: center.y + CGFloat(y))
}

fileprivate func calculateTextSize(text: String, font: UIFont) -> CGSize {
    let label = UILabel()
    label.font = font

    label.text = text
    label.sizeToFit()

    return label.frame.size
}
