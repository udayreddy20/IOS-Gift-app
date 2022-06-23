//
//  BookingVC.swift

import UIKit

class BookingVC: UIViewController {

    
    @IBOutlet weak var tblList: UITableView!
    
    
    var array = [OrderModel]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let email = GFunction.user.email {
            self.getData(email: email)
        }
    }

}

extension BookingVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "BookingCell", for: indexPath) as! BookingCell
        cell.configCell(data: self.array[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }
    
}

class BookingCell : UITableViewCell {
    @IBOutlet weak var vwCell: UIView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTName: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblBooking: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblSeatNumber: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.vwCell.layer.cornerRadius = 10.0
    }
    
    func configCell(data: OrderModel){
        self.lblTName.text = "Theater Name: \(data.theaterName.description)"
        self.lblDate.text = "Movie Date: \(data.date.description)"
        self.lblName.text = "Movie Name: \(data.movieName.description)"
        self.lblPrice.text = "Price: $\(data.price.description)"
        self.lblSeatNumber.text = "Seat: \(data.seatNumber.description)"
        self.lblBooking.text = "BookingID: \(data.bookingNumber.description)"
    }
}


//MARK:- API
extension BookingVC {
    func getData(email:String){
        _ = AppDelegate.shared.db.collection(eOrder).whereField(eEmail, isEqualTo: email).addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            self.array.removeAll()
            if snapshot.documents.count != 0 {
                for data in snapshot.documents {
                    let data1 = data.data()
                    if let email: String = data1[eEmail] as? String, let movieName: String = data1[eMovieName] as? String, let theaterName: String = data1[eTheaterName] as? String, let date: String = data1[eOrderDate] as? String, let seatNumber: String = data1[eSeatNumber] as? String,let price: String = data1[eOrderAmount] as? String, let bookingNumber: String = data1[eBookingNumber] as? String {
                        self.array.append(OrderModel(docID: data.documentID, email: email, bookingNumber: bookingNumber, movieName: movieName, theaterName: theaterName, date: date, seatNumber: seatNumber, price: price))
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
