import UIKit

class BaseViewController: UIViewController {
    var model: Model
    private let bindings: Bindings

    private var button: UIButton = {
        let b = UIButton(type: .roundedRect)
        b.setTitle("Go!", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: 20)
        b.backgroundColor = UIColor.yellow
        b.addTarget(self, action: #selector(action), for: .touchUpInside)
        return b
    }()

    private var label: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.yellow
        l.text = "Never see me"
        return l
    }()

    private var textField: UITextField = {
        let t = UITextField(frame: .zero)
        t.translatesAutoresizingMaskIntoConstraints = false
        t.backgroundColor = UIColor.white
        return t
    }()

    init(model: Model, bindings: Bindings) {
        self.model = model
        self.bindings = bindings
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = model.text
        setup()
    }

    func setup() {
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            textField.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 20),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),

            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.bottomAnchor, constant: -80),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            ])
    }

    @objc func action() {
        bindings.go(textField.text)
    }

    func clear() {
        textField.text = ""
    }
}
