//
//  FavouriteVC.swift
//  FlowerApp


import UIKit

class FavouriteVC: UIViewController {

    //MARK:- Outlets
    @IBOutlet weak var tblList: SelfSizedTableView!
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    
    //MARK:- Action Methods
    
    //MARK:- ViewLifeCycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblList.delegate = self
        self.tblList.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
    }

}


extension FavouriteVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavouriteCell", for: indexPath) as! FavouriteCell
        
        cell.btnRemove.addAction(for: .touchUpInside) {
            Alert.shared.showAlert("", actionOkTitle: "Remove", actionCancelTitle: "Cancel", message: "Are you sure you want to remove this bouquet?") { (true) in
                
                Alert.shared.showAlert(message: "This bouquet is removed from favourite !!!", completion: nil)
                
            }
        }
        
        return cell
    }
    
    
}


class FavouriteCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var vwMain: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var btnRemove: UIButton!
    
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwMain.backgroundColor = .white
        self.vwMain.shadow()
        self.vwMain.layer.cornerRadius = 10.0
    }
}
