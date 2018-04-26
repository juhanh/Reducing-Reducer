//
//  RedViewController.swift
//  Reducing Reducer
//
//  Created by Juhan Hion on 26.04.18.
//  Copyright © 2018 TransferWise Ltd. All rights reserved.
//

import UIKit

class RedModel: Model { }
class RedBindings: Bindings { }

class RedViewController: BaseViewController {
    override func setup() {
        super.setup()
        view.backgroundColor = UIColor.red
        title = "Red"
    }
}
