import Foundation

public enum LoadingCommand {
    case load(model: RoutingModel, callback: (String) -> ())
}

public protocol Loader {
    func load(_ command: LoadingCommand)
}

public class LoaderImpl: Loader {
    public init() { }
    
    public func load(_ command: LoadingCommand) {
        switch command {
        case let .load(model, callback):
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(3)) {
                callback(model.text + "\nDone!")
            }
        }
    }
}
