import Foundation

public enum FlowStep {
    case start
    case blue
    case red
    case green
    case finish
}

enum Action {
    case sync(route: RoutingCommand)
    case async(route: RoutingCommand, load: LoadingCommand)
}

public class Flow {
    private let router: Router
    private let loader: Loader
    private let calculator: StepCalculator
    private var state: FlowState

    public convenience init(router: Router,
                            loader: Loader) {
        self.init(router: router, loader: loader, calculator: StepCalculatorImpl())
    }

    init(router: Router,
         loader: Loader,
         calculator: StepCalculator) {
        self.router = router
        self.loader = loader
        self.calculator = calculator
        self.state = FlowState()
    }

    public func nextStep() {
        let step = calculator.calculateNextStep(from: state)
        processNextStep(step)
    }

    private func processNextStep(_ step: FlowStep) {
        switch step {
        case .start:
            processStep(StartStep())
        case .blue:
            processStep(BlueStep())
        case .red:
            processStep(RedStep())
        case .green:
            processStep(GreenStep())
        case .finish:
            processStep(DoneStep())
        }
    }

    private func processStep<T>(_ : T) where T: Step {
        let result = T.process(state as! T.StepState, processingEndCallback: { [weak self] newState in
            self?.state = newState as! FlowState
            self?.nextStep()
        })
        switch result {
        case let .async(route, load):
            router.route(route)
            loader.load(load)
        case let .sync(route):
            router.route(route)
        }
    }
}
