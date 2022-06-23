//
//  AdminVC.swift


import UIKit

class AdminVC: UIViewController {

    
    @IBOutlet weak var vwGerne: UIView!
    @IBOutlet weak var vwMovie: UIView!
    @IBOutlet weak var vwTheater: UIView!
    
    
    
    func setupView() {
        self.vwGerne.shadowView()
        self.vwMovie.shadowView()
        self.vwTheater.shadowView()
        
        self.setUpTouch(sender: vwGerne, type: GerneListVC.self)
        self.setUpTouch(sender: vwMovie, type: AdminMovieListVC.self)
        self.setUpTouch(sender: vwTheater, type: AdminTheaterListVC.self)
    }
    
    func setUpTouch(sender: UIView, type: UIViewController.Type) {
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: type) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        sender.isUserInteractionEnabled = true
        sender.addGestureRecognizer(tap)
    }
    
    @IBAction func btnLogoutClick(_ sender: UIButton) {
        UIApplication.shared.setStart()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
}
