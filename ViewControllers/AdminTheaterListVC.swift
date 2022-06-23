//
//  AdminTheaterListVC.swift


import UIKit

class AdminTheaterListVC: UIViewController {

    @IBOutlet weak var tblList: UITableView!
    @IBOutlet weak var vwMainback: UIView!
    @IBOutlet weak var btnAddMovie: UIButton!
    
    var array = [TheaterModel]()
    
    @IBAction func btnAddNewClick(_ sender: UIButton){
        if let vc = UIStoryboard.main.instantiateViewController(withClass: AddTheaterVC.self) {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.getData()
    }
}


extension AdminTheaterListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TheaterCell", for: indexPath) as! TheaterCell
        let data = self.array[indexPath.row]
        cell.configCell(data: data)
        let tap = UITapGestureRecognizer()
        tap.addAction {
            if let vc = UIStoryboard.main.instantiateViewController(withClass: AddTheaterVC.self) {
                vc.data = data
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        cell.vwCell.isUserInteractionEnabled = true
        cell.vwCell.addGestureRecognizer(tap)
        cell.selectionStyle = .none
        return cell
    }
}



//MARK:- API
extension AdminTheaterListVC {
    func getData(){
        _ = AppDelegate.shared.db.collection(eTheaterList).addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let name: String = data1[eName] as? String, let rate: String = data1[eReview] as? String, let row: String = data1[eSeatRow] as? String, let column: String = data1[eSeatColumn] as? String, let location: String = data1[eAddress] as? String {
                        self.array.append(TheaterModel(docID: data.documentID, name: name, rate: rate, row: row, column: column, location: location))
                    }
                }
                self.tblList.delegate = self
                self.tblList.dataSource = self
                self.tblList.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
}
