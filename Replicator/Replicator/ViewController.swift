//
//  ViewController.swift
//  Replicator
//
//  Created by joey on 10/31/19.
//  Copyright © 2019 TGI Technology. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dashBoard: UIView!
    @IBOutlet weak var someLabel: UILabel!
    @IBOutlet weak var degreeSlider: UISlider!

    var myDegrees: CGFloat = 0 {
        didSet {
            updateRotation()
        }
    }

    var itemCount: Int = 24 {
        didSet {
            updateTextLayers()
        }
    }

    var textLayers:[CATextLayer] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        updateTextLayers()
        drawDashes(onView: dashBoard, count: itemCount)
        drawText(onView: dashBoard, withTextLayers: textLayers)
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 5) {
            self.dashBoard.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        }
    }

    @IBAction func valueChanged(_ sender: UISlider) {
        myDegrees = CGFloat(sender.value)
        someLabel.text = "\(sender.value)"
    }

}

// MARK: -
fileprivate extension ViewController {
    func updateTextLayers() {
        textLayers.removeAll()
        for _ in 1...itemCount {
            let textLayer = CATextLayer()
            textLayers.append(textLayer)
        }
    }

    func updateRotation() {
        let radians = CGFloat(myDegrees * CGFloat.pi / 180)
        textLayers.forEach { (myLayer) in
            myLayer.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        }
    }
}

// MARK: - Drawing
func drawDashes(onView view: UIView, count: Int) {
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

func drawText(onView view: UIView, withTextLayers textLayers: [CATextLayer]) {
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
func drawCenterPoint(forView view: UIView) {
    let centerPoint = CALayer()

    let width: CGFloat = 10.0
    let height: CGFloat = 10.0

    centerPoint.frame = CGRect(x: view.bounds.midX - width/2, y: view.bounds.midY - height/2, width: width, height: height)
    centerPoint.cornerRadius = width/2
    centerPoint.backgroundColor = UIColor.white.cgColor
    view.layer.addSublayer(centerPoint)
}

func calculateOrigin(center: CGPoint, angle: CGFloat, radius: CGFloat) -> CGPoint {
    let x = Float(radius) * cosf(Float(angle))
    let y = Float(radius) * sinf(Float(angle))

    return CGPoint(x: center.x + CGFloat(x), y: center.y + CGFloat(y))
}

func calculateTextSize(text: String, font: UIFont) -> CGSize {
    let label = UILabel()
    label.font = font

    label.text = text
    label.sizeToFit()

    return label.frame.size
}
