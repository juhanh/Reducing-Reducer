public enum ValidationCommand {
    
}

public protocol Validator {
    func validate(_ command: ValidationCommand)
}

public class ValidatorImpl: Validator {
    public init() { }
    
    public func validate(_ command: ValidationCommand) {
        switch command {
        default:
            return
        }
    }
}
