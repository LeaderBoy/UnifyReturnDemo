
import UIKit


class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    private func setUp() {
        
        let vc = [ViewController(),UIViewController(),UIViewController(),UIViewController()]
        let titleArray = ["界面1","界面2","界面3","界面4"]
        let imageArray = [#imageLiteral(resourceName: "attention"),#imageLiteral(resourceName: "attention"),#imageLiteral(resourceName: "attention"),#imageLiteral(resourceName: "attention")]
        let selectedImageArray = [#imageLiteral(resourceName: "attention_s"),#imageLiteral(resourceName: "attention_s"),#imageLiteral(resourceName: "attention_s"),#imageLiteral(resourceName: "attention_s")]
        
        var viewControllersArray = [UINavigationController]()
        
        for i in 0 ..< vc.count {
            vc[i].title = titleArray[i]
            vc[i].tabBarItem.title = titleArray[i]
            vc[i].tabBarItem.image = imageArray[i].withRenderingMode(.alwaysOriginal)
            vc[i].tabBarItem.selectedImage = selectedImageArray[i].withRenderingMode(.alwaysOriginal)
            vc[i].tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : #colorLiteral(red: 0.2941176471, green: 0.6745098039, blue: 0.6666666667, alpha: 1)], for: .selected)
            let nav = UINavigationController(rootViewController: vc[i])
            nav.navigationBar.barStyle = .black
            viewControllersArray.append(nav)
        }
        
        self.viewControllers = viewControllersArray        
    }
    
}
