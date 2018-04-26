//
//  ViewController.swift
//  Reducing Reducer
//
//  Created by Juhan Hion on 26.04.18.
//  Copyright © 2018 TransferWise Ltd. All rights reserved.
//

import UIKit

class BlueModel: Model { }
class BlueBindings: Bindings { }

class BlueViewController: BaseViewController {
    override func setup() {
        super.setup()
        view.backgroundColor = UIColor.blue
        title = "Blue"
    }
}

