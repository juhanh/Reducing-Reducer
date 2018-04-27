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

class Flow {
    private let router: Router
    private var state: String?

    init(router: Router) {
        self.router = router
        state = nil
    }

    func route(instruction: Instruction) {
        switch instruction {
        case .start:
            processStep(state: nil, step: BlueStep())
        case let .blue(previous):
            processStep(state: previous, step: BlueStep())
        case let .red(previous):
            processStep(state: previous, step: RedStep())
        case let .green(previous):
            processStep(state: previous, step: GreenStep())
        case .done:
            router.process(command: .done)
        }
    }

    private func processStep<T>(state: String?, step _: T) where T: Step {
        let result = T.process(state: state as? T.State, callback: { [weak self] in self?.route(instruction: $0) })
        self.state = result.state as? String
        router.process(command: result.command)
    }
}
