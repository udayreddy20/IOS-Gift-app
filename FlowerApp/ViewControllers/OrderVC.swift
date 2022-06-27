//
//  OrderVC.swift
//  FlowerApp


import UIKit

class OrderVC: UIViewController {

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

extension OrderVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderedCell", for: indexPath) as! OrderedCell
        return cell
    }
    
    
}

class OrderedCell: UITableViewCell {
    //MARK:- Outlets
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var imgData: UIImageView!
    @IBOutlet weak var vwMain: UIView!
    
    
    //MARK:- Class Variables
    
    //MARK:- Custom Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.vwMain.layer.cornerRadius = 10.0
        self.vwMain.backgroundColor = .white
        self.vwMain.shadow()
    }
}
