protocol StepCalculator {
    func calculateNextStep(from state: FlowState) -> FlowStep
}

class StepCalculatorImpl: StepCalculator {
    func calculateNextStep(from state: FlowState) -> FlowStep {
        if state.isDoneFilled { return .finish }
        if state.isGreenFilled { return .green }
        if state.isRedFilled { return .red }
        if state.isBlueFilled { return .blue }
        else { return .start }
    }
}

private extension FlowState {
    var isStartFilled: Bool {
        return !start.isNullOrEmpty
    }

    var isBlueFilled: Bool {
        return isStartFilled && !blue.isNullOrEmpty
    }

    var isRedFilled: Bool {
        return isBlueFilled && !red.isNullOrEmpty
    }

    var isGreenFilled: Bool {
        return isRedFilled && !green.isNullOrEmpty
    }

    var isDoneFilled: Bool {
        return isGreenFilled && !done.isNullOrEmpty
    }
}

extension Optional where Wrapped == String {
    var isNullOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
