import Foundation

enum LoadingCommand {
    case load(model: Model, callback: (Model) -> ())
}

class Loader {
    func load(command: LoadingCommand) {
        switch command {
        case let .load(model, callback):
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(3)) {
                callback(model)
            }
        }
    }
}
