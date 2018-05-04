extension FlowState {
    var startModel: BlueModel {
        return BlueModel(text: start)
    }

    var redModel: RedModel? {
        guard let blue = blue, !blue.isEmpty else { return nil }
        return RedModel(text: "Blue: \(blue)")
    }

    var greenModel: GreenModel? {
        guard let blue = blue, !blue.isEmpty, let red = red, !red.isEmpty else { return nil }
        return GreenModel(text: "Blue: \(blue), Red: \(red)")
    }

    var doneModel: DoneModel? {
        guard let blue = blue, !blue.isEmpty,
            let red = red, !red.isEmpty,
            let green = green, !green.isEmpty else { return nil }
        return DoneModel(text: "Blue: \(blue), Red: \(red), Green: \(green)")
    }
}

public class BlueModel: RoutingModel {
    public let text: String

    public init(text: String) {
        self.text = text
    }
}

public class RedModel: RoutingModel {
    public let text: String

    public init(text: String) {
        self.text = text
    }
}

public class GreenModel: RoutingModel {
    public let text: String

    public init(text: String) {
        self.text = text
    }
}
