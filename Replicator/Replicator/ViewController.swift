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

    @IBOutlet weak var angleLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    var myAngle: CGFloat = 0 {
        didSet {
            drawText(onView: dashBoard, count: 24)
            //addLabels(onView: dashBoard, count: 24)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        slider.minimumValue = -360
        slider.maximumValue = 360

        drawDashes(onView: dashBoard, count: 24)
        drawText(onView: dashBoard, count: 24)
        //addLabels(onView: dashBoard, count: 24)

    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 5) {
            self.dashBoard.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
        }
    }

    @IBAction func valueChanged(_ sender: UISlider) {
        myAngle = CGFloat(sender.value)
        angleLabel.text = "\(sender.value)"
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

func drawText(onView view: UIView, count: Int) {

    for layer in view.layer.sublayers ?? [] where layer is CATextLayer {
        layer.removeFromSuperlayer()
    }

    let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    let offset: CGFloat = 110.0

    drawCenterPoint(forView: view)

    for index in 1...count {
        let textLayer = CATextLayer()
        textLayer.fontSize = 16
        textLayer.backgroundColor = UIColor.lightGray.cgColor
        textLayer.string = "\(index * 10)"
        textLayer.alignmentMode = .center

        let angle: CGFloat = CGFloat(index) * (CGFloat.pi * 2.0 / CGFloat(count))
        let degrees: Double = Double(360.0) / Double(count)
        let radians = degreesToRadians(45.0)

        textLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        textLayer.transform = CATransform3DMakeRotation(radians, 0.0, 0.0, 1.0)
        //textLayer.transform = CATransform3DRotate(textLayer.transform, radians, 1.0, 0.0, 0.0)

        let calculatedOrigin = calculateOrigin(center: center, angle: angle, radius: view.bounds.width/2 - offset)
        let textSize = calculateTextSize(text: "\(index * 10)", font: UIFont.systemFont(ofSize: 26))
        let layerX: CGFloat = calculatedOrigin.x - textSize.width/2
        let layerY: CGFloat = calculatedOrigin.y - textSize.height/2

        textLayer.frame = CGRect(x: layerX, y: layerY, width: textSize.width, height: textSize.height)
        view.layer.addSublayer(textLayer)
    }
}

func addLabels(onView view: UIView, count: Int) {

    for view in view.subviews where view is UILabel {
        view.removeFromSuperview()
    }

    let center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
    let offset: CGFloat = 110.0

    //let labelSize: CGSize = CGSize(width: 100, height: 100)

    drawCenterPoint(forView: view)

    for index in 1...count {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.backgroundColor = UIColor.lightGray
        label.text = "\(index * 10)"
        label.textAlignment = .center
        label.sizeToFit()

        let angle: CGFloat = CGFloat(index) * (CGFloat.pi * 2.0 / CGFloat(count))
        label.rotate(degrees: 90)

        //let angle: CGFloat = CGFloat(index) * (CGFloat.pi * 2.0 / CGFloat(count))
        //label.transform = CGAffineTransform(rotationAngle: myAngle)
        //label.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        //textLayer.transform = CATransform3DMakeRotation(myAngle, 1.0, 1.0, 1.0)
        //textLayer.transform = CATransform3DRotate(textLayer.transform, myAngle, 0.0, 0.0, 1.0)

        let calculatedOrigin = calculateOrigin(center: center, angle: angle, radius: view.bounds.width/2 - offset)
        //let textSize = calculateTextSize(text: "\(index * 10)", font: UIFont.systemFont(ofSize: 26))
        let layerX: CGFloat = calculatedOrigin.x - label.bounds.width / 2
        let layerY: CGFloat = calculatedOrigin.y - label.bounds.height / 2

        label.frame = CGRect(x: layerX, y: layerY, width: label.bounds.width, height: label.bounds.height)
        view.addSubview(label)
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
    let x3 = Float(radius) * cosf(Float(angle))
    let y3 = Float(radius) * sinf(Float(angle))

    return CGPoint(x: center.x + CGFloat(x3), y: center.y + CGFloat(y3))
}

func calculateTextSize(text: String, font: UIFont) -> CGSize {
    let label = UILabel()
    label.font = font

    label.text = text
    label.sizeToFit()

    return label.frame.size
}

func degreesToRadians(_ degrees: Double) -> CGFloat {
  return CGFloat(degrees * .pi / 180.0)
}

// MARK: -
extension UIView {

    /**
     Rotate a view by specified degrees

     - parameter angle: angle in degrees
     */
    func rotate(degrees: CGFloat) {
        let radians = degrees / 180.0 * CGFloat.pi
        let rotation = self.transform.rotated(by: radians);
        self.transform = rotation
    }

}

