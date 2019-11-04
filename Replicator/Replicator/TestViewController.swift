//
//  TestViewController.swift
//  Replicator
//
//  Created by joey on 11/4/19.
//  Copyright © 2019 TGI Technology. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {

    @IBOutlet weak var dashBoard: Dashboard!
    @IBOutlet weak var textField: UITextField!

    var count: Int = 0 {
        didSet {
            dashBoard.itemCount = count
        }
    }

    var grams: Float = 10 {
        didSet {
            dashBoard.pointTo(grams: grams)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        count = 12
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dashBoard.pointTo(grams: 16)
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        if let grams = (textField.text as NSString?)?.floatValue {
            dashBoard.pointTo(grams: grams)
        }
    }

}
