import Foundation

public enum FlowStep {
    case start
    case blue(previous: String)
    case red(previous: String)
    case green(previous: String)
    case finish(previous: String)
}

enum Action {
    case sync(route: RoutingCommand)
    case async(route: RoutingCommand, load: LoadingCommand)
}

public class Flow {
    private let router: Router
    private let loader: Loader
    private var state: FlowState

    public init(router: Router, loader: Loader) {
        self.router = router
        self.loader = loader
        state = FlowState()
    }

    public func nextStep(_ step: FlowStep) {
        switch step {
        case .start:
            processStep(input: "", state: state, step: StartStep())
        case let .blue(previous):
            processStep(input: previous, state: state, step: BlueStep())
        case let .red(previous):
            processStep(input: previous, state: state, step: RedStep())
        case let .green(previous):
            processAsyncStep(input: previous, state: state, step: GreenStep())
        case let .finish(previous):
            processStep(input: previous, state: state, step: DoneStep())
        }
    }

    private func processStep<T>(input: String, state: FlowState, step _: T) where T: Step {
        let result = T.process(input as! T.Input, inputState: state as! T.StepState, nextStepCallback: { [weak self] in
            self?.nextStep($0)
        })
        self.state = result.outputState as! FlowState
        if case let .sync(route) = result.action {
            router.route(route)
        }
    }

    private func processAsyncStep<T>(input: String, state: FlowState, step _: T) where T: AsyncStep {
        let result = T.processAsync(input as! T.Input, inputState: state as! T.StepState, processingEndCallback: { [weak self] in
            self?.state = $0.outputState as! FlowState
            self?.nextStep($0.step)
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
