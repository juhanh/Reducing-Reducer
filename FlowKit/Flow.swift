import Foundation

public enum FlowStep {
    case start
    case blue
    case red
    case green
    case finish
}

enum Action {
    case route(command: RoutingCommand)
    case loadAsync(route: RoutingCommand, command: LoadingCommand)
    case validate(command: ValidationCommand)
}

public class Flow {
    public typealias Dependencies = (
        router: Router,
        loader: Loader,
        validator: Validator
    )

    private let dependencies: Dependencies
    private let calculator: StepCalculator
    private var state: FlowState

    public convenience init(dependencies: Dependencies) {
        self.init(state: FlowState(),
                  dependencies: dependencies,
                  calculator: StepCalculatorImpl())
    }

    init (state: FlowState,
          dependencies: Dependencies,
          calculator: StepCalculator) {
        self.state = state
        self.dependencies = dependencies
        self.calculator = calculator
    }

    public func nextStep() {
        let step = calculator.calculateNextStep(from: state)
        processNextStep(step)
    }

    private func processNextStep(_ step: FlowStep) {
        switch step {
        case .start:
            processStep(StartStep.self)
        case .blue:
            processStep(BlueStep.self)
        case .red:
            processStep(RedStep.self)
        case .green:
            processStep(GreenStep.self)
        case .finish:
            processStep(DoneStep.self)
        }
    }

    private func processStep<T: Step>(_ stepType: T.Type) {
        let result = stepType.process(state as! T.StepState, completion: { [weak self] in
            self?.state = $0 as! FlowState
            self?.nextStep()
        })
        switch result {
        case let .loadAsync(route, load):
            dependencies.router.route(route)
            dependencies.loader.load(load)
        case let .route(route):
            dependencies.router.route(route)
        case let .validate(validate):
            dependencies.validator.validate(validate)
        }
    }
}
