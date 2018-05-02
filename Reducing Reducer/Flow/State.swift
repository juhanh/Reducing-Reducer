struct State {
    let start = "Hello!"
    var blue: String?
    var red: String?
    var green: String?
}

extension State {
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
