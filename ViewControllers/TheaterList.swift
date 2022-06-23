//
//  TheaterList.swift


import UIKit

class TheaterListVC: UIViewController {

    @IBOutlet weak var tbllist: UITableView!
    
    var movieData: MovieModel!
    var selectedDate: Date!
    var array = [TheaterModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
}

extension TheaterListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "TheaterCell", for: indexPath) as! TheaterCell
        cell.configCell(data: self.array[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: SeatSelectionVC.self) {
            vc.movieData = self.movieData
            vc.selectedDate = self.selectedDate
            vc.theaterData = self.array[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}


class TheaterCell: UITableViewCell {
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var lblTName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblRatings: UILabel!
    @IBOutlet weak var lblIsOpen: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 10.0
        self.lblIsOpen.isHidden = true
    }
    
    func configCell(data: TheaterModel){
        self.lblTName.text = data.name.description
        self.lblLocation.text = data.location.description
        self.lblRatings.text = "Ratings: \(data.rate.description)"
    }
}


//MARK:- API
extension TheaterListVC {
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
                self.tbllist.delegate = self
                self.tbllist.dataSource = self
                self.tbllist.reloadData()
            }else{
                Alert.shared.showAlert(message: "No Data Found !!!", completion: nil)
            }
        }
    }
}

