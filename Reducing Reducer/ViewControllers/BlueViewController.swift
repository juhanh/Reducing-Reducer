import UIKit
import FlowKit

class BlueBindings: Bindings { }

class BlueViewController: BaseViewController {
    init(model: BlueModel, bindings: BlueBindings) {
        super.init(model: model, bindings: bindings)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setup() {
        super.setup()
        view.backgroundColor = UIColor.blue
        title = "Blue"
    }
}

