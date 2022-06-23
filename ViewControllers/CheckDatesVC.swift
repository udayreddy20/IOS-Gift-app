//
//  CheckDatesVC.swift


import UIKit
import FSCalendar

class CheckDatesVC: UIViewController {

    @IBOutlet weak var startDateCalendar: FSCalendar!
    var movieData: MovieModel!
    
    func setUpView(){
        self.applyStyle()
        
        self.startDateCalendar.delegate = self
        self.startDateCalendar.dataSource = self
        
        self.calendarSetup()
    }
    
    func applyStyle(){
        
    }
    
    func calendarSetup(){
        self.startDateCalendar.appearance.headerTitleColor = .black
        self.startDateCalendar.headerHeight = 45
        self.startDateCalendar.appearance.titleTodayColor = .black
        self.startDateCalendar.placeholderType = .none
    }
    
    //MARK:- Action Method
    @IBAction func btnProccedTapped(_ sender: Any) {
        if let vc = UIStoryboard.main.instantiateViewController(withClass: TheaterListVC.self) {
//            vc.data = self.data
            vc.movieData = self.movieData
            vc.selectedDate = self.startDateCalendar.selectedDate
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpView()
        // Do any additional setup after loading the view.
    }
}


extension CheckDatesVC: FSCalendarDelegate,FSCalendarDataSource {
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    func maximumDate(for calendar: FSCalendar) -> Date {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 7

        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? Date()
        
        return futureDate
    }
}
