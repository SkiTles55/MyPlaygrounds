import UIKit
import PinLayout
import PlaygroundSupport

class TestVC: UIViewController {
    override func viewDidLoad() {
        setupSubviews()
    }
    
    private func setupSubviews() {
        // add Subviews
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // pin elements with .layout() at end
    }
}

let vc = TestVC()
let navbar = UINavigationController(rootViewController: vc)

PlaygroundPage.current.liveView = navbar
