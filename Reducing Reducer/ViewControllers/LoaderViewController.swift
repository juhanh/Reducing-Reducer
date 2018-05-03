import UIKit

class LoaderViewController: UIViewController {
    private var loader: UIActivityIndicatorView = {
        let r = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        r.startAnimating()
        r.translatesAutoresizingMaskIntoConstraints = false
        return r
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    private func setup() {
        view.backgroundColor = UIColor.gray
        view.alpha = 1
        view.isUserInteractionEnabled = false
        view.addSubview(loader)
        NSLayoutConstraint.activate([
            loader.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
    }
}
