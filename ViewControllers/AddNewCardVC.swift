//
//  AddNewCardVC.swift


import UIKit

class AddNewCardVC: UIViewController {

    //UIButton
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var btnCheck: UIButton!
    
    //UITextField
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var txtCardName: UITextField!
    @IBOutlet weak var txtExpiryDate: UITextField!
    
    //UIView
    @IBOutlet weak var vwName: UIView!
    @IBOutlet weak var vwCredentials: UIView!
    
    //UIImageView
    @IBOutlet weak var imgLogo: UIImageView!
    
    private let expPicker = UIPickerView()
    private var arrayMonth = [String]()
    private var arrayYear = [String]()
    
    private var components = DateComponents()
    private var currentcalender : Calendar!
    private let date = Date()
    private let units: Set<Calendar.Component> = [.hour, .day, .month, .year, .minute, .second]
    private let dateFormatter = DateFormatter()
    private var monthText : String = String()
    private var monthNumber : String = String()
    private var yearText : String = String()
    
    
    var theaterData : TheaterModel!
    var movieData: MovieModel!
    var selectedDate: Date!
    var selectedSeats: [IndexPath]!
    
    private func setUpView() {
        self.applyStyle()
    }
    
    
    private func applyStyle(){
        
        self.btnAdd.layer.cornerRadius = 7.0
        
        self.vwName.layer.cornerRadius = 12.0
        self.vwName.layer.borderColor = UIColor.colorLine.cgColor
        self.vwName.layer.borderWidth = 1.0
        
        
        self.vwCredentials.layer.cornerRadius = 12.0
        self.vwCredentials.layer.borderColor = UIColor.colorLine.cgColor
        self.vwCredentials.layer.borderWidth = 1.0
        
        self.txtCVV.textAlignment = .center
        self.txtCVV.delegate = self
        self.txtExpiryDate.delegate = self
        self.txtCardNumber.delegate = self
        self.txtCardName.delegate = self
        
    }
    
    func UTCToDate(date:Date) -> String {
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let myString = formatter.string(from: date) // string purpose I add here
        let yourDate = formatter.date(from: myString)  // convert your string to date
        formatter.dateFormat = "dd, MMM, yyyy"  //then again set the date format whhich type of output you need
        return formatter.string(from: yourDate!) // again convert your date to string
    }
    
    
    private func setPicker() {
        currentcalender = Calendar(identifier: .gregorian)
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        currentcalender.locale = Locale(identifier: "en_US")
        dateFormatter.locale = Locale(identifier: "en_US")
        
        self.expPicker.dataSource = self
        self.expPicker.delegate = self
        
        
        components = currentcalender.dateComponents(units, from: date)
        arrayMonth = ["01","02","03","04","05","06","07","08","09","10","11","12"]
        
        for month in 0...24 {
            let monthComponents = currentcalender.component(.year, from: currentcalender.date(byAdding: .year, value: month, to: Date())!)
            arrayYear.append(String(monthComponents))
        }
        yearText = arrayYear[0]
        monthText = arrayMonth[0]
        self.txtExpiryDate.inputView = self.expPicker
    }
    
    @IBAction func btnCheckClick(_ sender: UIButton){
        sender.isSelected.toggle()
    }
    
    @IBAction func btnSaveClick(_ sender: Any){
        let error = self.validation()
        if error == "" {
            let value = arc4random_uniform(30 + 1)
            let value1 = arc4random_uniform(9999 + 1)
            
            let df: DateFormatter = DateFormatter()
            df.dateFormat = "yyyyMMddHHmm"
            
            let dateString: String = df.string(from: Date())
            let bookingID = "\(dateString)\(value1)"
            if let user = GFunction.user, let movieData = self.movieData, let selectedDate : String = self.UTCToDate(date: self.selectedDate) as? String, let theaterData = self.theaterData {
                self.addCard(name: self.txtCardName.text ?? "", number: self.txtCardNumber.text ?? "", cvv: self.txtCVV.text ?? "", expDate: self.txtExpiryDate.text ?? "" , email: user.email!)
                self.createOrder(data: movieData, user: user, date: selectedDate, theaterData: theaterData, seatNumber: value.description, bookingNumber: bookingID)
            }
        }else{
            Alert.shared.showAlert(message: error, completion:  nil)
        }
        
//        self.navigationController?.popViewController(animated: true)
    }
    
    
    func validation() -> String {
        if self.txtCardNumber.text?.trim() == "" {
            return "Please enter card number"
        }else if self.txtCardNumber.text?.count != 16 {
            return "Please enter valid card number"
        }else if self.txtCardName.text?.trim() == "" {
            return "Please enter card holder name"
        }else if self.txtExpiryDate.text?.trim() == "" {
            return "Please enter expiry date"
        }else if self.txtExpiryDate.text?.count != 7 {
            return "Please enter valid exp date"
        }else if self.txtCVV.text?.trim() == "" {
            return "Please enter cvv"
        }else if self.txtCVV.text?.count != 3 {
            return "Please enter valid cvv"
        }
        return ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.txtCVV.layer.cornerRadius = 7.0
        }
        self.setUpView()
        // Do any additional setup after loading the view.
    }
}


extension AddNewCardVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return self.arrayMonth.count
        } else if component == 1 {
            return self.arrayYear.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return arrayMonth[row]
        } else if component == 1 {
            return arrayYear[row]
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if component == 0{
            dateFormatter.dateFormat = "MM"
            if let _ = dateFormatter.date(from: arrayMonth[row]) {
                let order = currentcalender.compare(dateFormatter.date(from: arrayMonth[row])!, to: dateFormatter.date(from: "\(components.month!)")!, toGranularity: .month)
                
                if order == .orderedAscending && yearText == arrayYear[0] {
                    self.expPicker.selectRow(components.month! - 1, inComponent: 0, animated: true)
                    monthText = arrayMonth[components.month! - 1]
                }else{
                    monthText = arrayMonth[row]
                }
                
            } else {
                monthText = arrayMonth[row]
            }
            
        } else {
            
            yearText = arrayYear[row]
            
            // pls check monthtext if you change format
            if arrayMonth.firstIndex(of: monthText)! < (components.month! - 1) && yearText == arrayYear[0] {
                self.expPicker.selectRow(components.month! - 1, inComponent: 0, animated: true)
                monthText = arrayMonth[components.month! - 1]
            }
        }
        
        self.txtExpiryDate.text = monthText + " / " + yearText.dropFirst(2)
    }
    
}

extension AddNewCardVC : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        //TxtMobileNumber allowed only Digits, - and maximum 12 Digits allowed
        if textField == txtCardNumber {
            if ((string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) && textField.text!.count < 16) || string.isEmpty{
                return true
            }
        }

        if textField == txtCardName {
            if ((string.rangeOfCharacter(from: CharacterSet.letters) != nil || string.rangeOfCharacter(from: CharacterSet.whitespaces) != nil) || string.isEmpty) {
                return true
            }
        }

        //TxtDate allowed only Digits, / and maximum 6 Digits allowed
        if textField == txtExpiryDate {
            if ((string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) && textField.text!.count < 7) || string.isEmpty{
                if (textField.text?.count == 2) && !string.isEmpty {
                    textField.text?.append(" / ")
                }
                return true
            }
//            self.setPicker()
        }

        //TxtCVV allowed only 3 Digits
        if textField == txtCVV {
            textField.textAlignment = .center
            if ((string.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil) && textField.text!.count < 3) || string.isEmpty{
                return true
            }
        }
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
         if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
         } else {
            textField.resignFirstResponder()
         }
         return false
      }
}


//MARK:- API
extension AddNewCardVC {
    func createOrder(data:MovieModel, user:UserModel,date:String,theaterData: TheaterModel,seatNumber:String,bookingNumber:String){
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(eOrder).addDocument(data:
            [
                eMovieName : data.name.description,
                eTheaterName : theaterData.name.description,
                eEmail: user.email?.description,
                eOrderDate : date,
                eOrderAmount: data.price,
                eSeatNumber: seatNumber,
                eBookingNumber: bookingNumber
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
                Alert.shared.showAlert(message: "Your ticket has been booked successfully !!!") { (true) in
                    if let vc = UIStoryboard.main.instantiateViewController(withClass: SuccessMessageVC.self) {
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }

    
    func addCard(name:String,number:String,cvv:String,expDate:String,email:String){
        var ref : DocumentReference? = nil
        ref = AppDelegate.shared.db.collection(eCardList).addDocument(data:
            [
                eCardNumber: number,
                eCardName : name,
                eEmail: email,
                eCardExpiryDate : expDate,
                eCVV: cvv
                
            ])
        {  err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
}
