import Foundation

public enum RoutingCommand {
    case noop
    case showLoader
    case showBlue(model: RoutingModel, bindings: Bindings)
    case showRed(model: RoutingModel, bindings: Bindings)
    case showGreen(model: RoutingModel, bindings: Bindings)
    case done(model: RoutingModel)
}

public protocol RoutingModel {
    var text: String { get }
}

open class Bindings {
    public let go: (String) -> ()

    public init(go: @escaping (String) -> ()) {
        self.go = go
    }
}

public protocol Router {
    func route(_ command: RoutingCommand)
}
