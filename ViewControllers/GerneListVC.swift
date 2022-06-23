//
//  GerneListVC.swift

import UIKit

class GerneListVC: UIViewController {

    @IBOutlet weak var tbllist: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    
    
    var array = [GerneModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.getData()
    }
    
    @IBAction func btnAddClick(_ sender: UIButton){
        if let vc = UIStoryboard.main.instantiateViewController(withClass: AddGerneVC.self){
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


extension GerneListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "GerneCell", for: indexPath) as! GerneCell
        cell.selectionStyle = .none
        let data = self.array[indexPath.row]
        cell.configCell(data: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = self.array[indexPath.row]
        if let vc = UIStoryboard.main.instantiateViewController(withClass: AddGerneVC.self){
            vc.data = data
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


class GerneCell: UITableViewCell {
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var lblTName: UILabel!
    @IBOutlet weak var btnEdit: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 10.0
        self.btnEdit.layer.cornerRadius = 8.0
        self.btnDelete.layer.cornerRadius = 8.0
    }
    
    func configCell(data: GerneModel){
        self.lblTName.text = data.name.description
    }
}


//MARK:- API
extension GerneListVC {
    func getData(){
        _ = AppDelegate.shared.db.collection(eGerne).addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[eName] as? String, let imagePath: String = data1[eImagePath] as? String {
                        self.array.append(GerneModel(docId: data.documentID, name: name, image: imagePath))
                    }
                }
                self.tbllist.delegate = self
                self.tbllist.dataSource = self
                self.tbllist.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
}

