import UIKit
import FlowKit

class GreenBindings: Bindings { }

class GreenViewController: BaseViewController {
    init(model: GreenModel, bindings: GreenBindings) {
        super.init(model: model, bindings: bindings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        view.backgroundColor = UIColor.green
        title = "Green"
    }
}
