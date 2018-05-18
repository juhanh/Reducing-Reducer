import Foundation

enum Action {
    case route(command: RoutingCommand)
    case loadAsync(route: RoutingCommand, command: LoadingCommand)
    case validate(command: ValidationCommand)
}

// This decalre the ordered flow.
// To add step, implement a Step and add it to its correct position
fileprivate let steps: [Step.Type] = [StartStep.self,
                                      BlueStep.self,
                                      RedStep.self,
                                      GreenStep.self,
                                      DoneStep.self]

public class Flow {
    public typealias Dependencies = (
        router: Router,
        loader: Loader,
        validator: Validator
    )

    private let dependencies: Dependencies
    private var state: FlowState

    public convenience init(dependencies: Dependencies) {
        self.init(state: FlowState(),
                  dependencies: dependencies)
    }

    init (state: FlowState,
          dependencies: Dependencies) {
        self.state = state
        self.dependencies = dependencies
    }

    public func nextStep() {
        guard let step = steps.first(where: { $0.shouldExecuteStep(state) }) else {
            // Handle error state in real world
            return
        }
        processStep(step)
    }

    private func processStep(_ stepType: Step.Type) {
        let result = stepType.process(state, completion: { [weak self] in
            self?.state = $0
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
