
import UIKit

class ViewController: UIViewController {
    
    lazy var tableView : UITableView = {
        $0.tableFooterView      = UIView()
        return $0
    }(UITableView(frame: .zero, style: .plain))

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }


}
extension ViewController : UITableViewDelegate,UITableViewDataSource {
    
    //MARK: 点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let otherVC = OtherViewController()
        self.navigationController?.pushViewController(otherVC, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cellID")
        }
        
        cell?.textLabel?.text = "测试" + "\(indexPath.row)"
        
        return cell!
    }
}

