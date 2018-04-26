//
//  GreenViewController.swift
//  Reducing Reducer
//
//  Created by Juhan Hion on 26.04.18.
//  Copyright © 2018 TransferWise Ltd. All rights reserved.
//

import UIKit

class GreenModel: Model { }
class GreenBindings: Bindings { }

class GreenViewController: BaseViewController {
    override func setup() {
        super.setup()
        view.backgroundColor = UIColor.green
        title = "Green"
    }
}
