//
//  TestRotateViewController.swift
//  Replicator
//
//  Created by joey on 11/1/19.
//  Copyright © 2019 TGI Technology. All rights reserved.
//

import UIKit

class TestRotateViewController: UIViewController {

    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var labelView: UIView!

    @IBOutlet weak var layerLabel: UILabel!
    @IBOutlet weak var labelLabel: UILabel!

    var layerAngle: CGFloat = 0 {
        didSet {
            drawText()
        }
    }

    var labelAngle: CGFloat = 0 {
         didSet {
             addLabel()
         }
     }

    override func viewDidLoad() {
        super.viewDidLoad()
        drawText()
        addLabel()
    }

    @IBAction func layerValueChanged(_ sender: UISlider) {
        layerLabel.text = "\(sender.value)"
        layerAngle = CGFloat(sender.value)
    }

    @IBAction func labelValueChanged(_ sender: UISlider) {
        labelLabel.text = "\(sender.value)"
        labelAngle = CGFloat(sender.value)
    }

    func drawText() {

        for layer in layerView.layer.sublayers ?? [] where layer is CATextLayer {
            layer.removeFromSuperlayer()
        }

        let textLayer = CATextLayer()
        textLayer.fontSize = 26
        textLayer.backgroundColor = UIColor.lightGray.cgColor
        textLayer.string = "Hello world"
        textLayer.alignmentMode = .center

        //let radians = degreesToRadians(45.0)

        //textLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        textLayer.transform = CATransform3DMakeRotation(layerAngle, 0.0, 0.0, 1.0)
        let textSize = calculateTextSize(text: "Hello world", font: UIFont.systemFont(ofSize: 26))

        let center = CGPoint(x: layerView.bounds.midX - textSize.width/2, y: layerView.bounds.midY - textSize.height/2)

        textLayer.frame = CGRect(origin: center, size: textSize)
        layerView.layer.addSublayer(textLayer)
    }

    func addLabel() {

        for view in labelView.subviews where view is UILabel {
            view.removeFromSuperview()
        }

        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 26)
        label.backgroundColor = UIColor.lightGray
        label.text = "Hello World"
        label.textAlignment = .center
        label.sizeToFit()

        label.rotate(angle: labelAngle)

        let center = CGPoint(x: labelView.bounds.midX - label.frame.width/2, y: labelView.bounds.midY - label.frame.height/2)
        label.frame = CGRect(origin: center, size: label.bounds.size)

        labelView.addSubview(label)
    }

}
