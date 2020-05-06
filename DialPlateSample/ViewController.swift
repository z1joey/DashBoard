//
//  ViewController.swift
//  DialPlateSample
//
//  Created by joey on 5/6/20.
//  Copyright © 2020 z1joey. All rights reserved.
//

import UIKit
import DialPlate

class ViewController: UIViewController {
    @IBOutlet weak var dialPlate: DialPlate!
    @IBOutlet weak var textField: UITextField!

    var count: Int = 0 {
        didSet {
            dialPlate.itemCount = count
        }
    }

    var grams: Float = 10 {
        didSet {
            dialPlate.pointTo(grams: grams)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        count = 12
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        if let grams = (textField.text as NSString?)?.floatValue {
            dialPlate.pointTo(grams: grams)
        }
    }
}

