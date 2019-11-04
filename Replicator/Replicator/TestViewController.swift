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

    override func viewDidLoad() {
        super.viewDidLoad()

        dashBoard.itemCount = 24
    }
    
}
