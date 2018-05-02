import UIKit

class RedModel: Model {
    let text: String

    init(text: String) {
        self.text = text
    }
}

class RedBindings: Bindings { }

class RedViewController: BaseViewController {
    init(model: RedModel, bindings: RedBindings) {
        super.init(model: model, bindings: bindings)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setup() {
        super.setup()
        view.backgroundColor = UIColor.red
        title = "Red"
    }
}
