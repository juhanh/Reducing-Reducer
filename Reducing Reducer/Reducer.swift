import Foundation

class Model {
    let text: String

    init(text: String) {
        self.text = text
    }
}

class Bindings {
    let go: (String?) -> ()

    init(go: @escaping (String?) -> ()) {
        self.go = go
    }
}

enum Instruction {
    case start
    case blue(previous: String?)
    case red(previous: String?)
    case green(previous: String?)
    case done
}

class Reducer {
    private let router: Router
    private var state: String?
    private let blueModel = Model(text: "Hello there")

    init(router: Router) {
        self.router = router
        state = nil
    }

    func route(instruction: Instruction) {
        switch instruction {
        case .start:
            showDefaultBlue()
        case let .blue(previous):
            handleBlue(previous: previous)
        case let .red(previous):
            handleRed(previous: previous)
        case let .green(previous):
            handleGreen(previous: previous)
        case .done:
            router.process(command: .done)
        }
    }

    fileprivate func showDefaultBlue() {
        let bindings = Bindings { [weak self] in
            self?.route(instruction: .blue(previous: $0))
        }
        router.process(command: .showBlue(model: blueModel, bindings: bindings))
    }

    private func handleBlue(previous: String?) {
        if let p = previous, !p.isEmpty {
            let model = Model(text: "Oh, you shouldn't have \(p)")
            let bindings = Bindings { [weak self] in
                self?.route(instruction: .red(previous: $0))
            }
            router.process(command: .showRed(model: model, bindings: bindings))
        } else {
            router.process(command: .restart(model: blueModel))
        }
    }

    private func handleRed(previous: String?) {
        if let p = previous, !p.isEmpty {
            let model = Model(text: "Really? \(p)")
            let bindings = Bindings { [weak self] in
                self?.route(instruction: .green(previous: $0))
            }
            router.process(command: .showGreen(model: model, bindings: bindings))
        } else {
            router.process(command: .restart(model: blueModel))
        }
    }

    private func handleGreen(previous: String?) {
        if let p = previous, !p.isEmpty {
            let model = Model(text: "Way cool! \(p)")
            let bindings = Bindings { [weak self] _ in
                self?.route(instruction: .done)
            }
            router.process(command: .showGreen(model: model, bindings: bindings))
        } else {
            router.process(command: .restart(model: blueModel))
        }
    }
}
