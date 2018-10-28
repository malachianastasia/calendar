import UIKit

var dateString = ""

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var Calendar: UICollectionView!
    @IBOutlet weak var MonthLabel: UILabel!
    let Months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    let DaysOfMonth = ["Monday", "Thuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    var DaysInMonths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    var currentMonth = String()
    var NumberOfEmptyBox = Int() //the number of empty boxes at the start of the current month
    var NextNumberOfEmptyBox = Int() //the same with above but with the next month
    
    var PreviousNumberOfEmptyBox = 0 ////the same with above but with the prev month
    
    var Direction = 0 //=0 if we are at the current month, =1 if we are in a future month, =-1 if we are in a past month
    
    var PositionIndex = 0//here we eill store the above vars of the empty boxes
    
    var LeapYearCounter = 2 //
    
    var dayCounter = 0
    
    var cellsArray: [UICollectionViewCell] = []
    
    var hDate = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        currentMonth = Months[month]
        
        MonthLabel.text = "\(currentMonth) \(year)"
        
        if weekday == 0{
            weekday = 7
        }
        GetStartDateDayPosition()
    }
    
    @IBAction func Next(_ sender: Any) {
        hDate = -1
        switch currentMonth{
        case "December":
            month = 0
            year += 1
            Direction = 1
            
            if LeapYearCounter < 5{
                LeapYearCounter += 1
            }
            if LeapYearCounter == 4{
                DaysInMonths[1] = 29
            }
            if LeapYearCounter == 5{
                LeapYearCounter = 1
                DaysInMonths[1] = 28
            }

            GetStartDateDayPosition()
            currentMonth = Months[month]
            
            MonthLabel.text = "\(currentMonth) \(year)"
            MoveAnimationNext(Label: MonthLabel)
            Calendar.reloadData()
            
        default:
            Direction = 1
            GetStartDateDayPosition()
            month += 1
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            MoveAnimationNext(Label: MonthLabel)
            Calendar.reloadData()
        }
    }
    
    @IBAction func Back(_ sender: Any) {
        hDate = -1
        switch currentMonth{
        case "January":
            month = 11
            year -= 1
            Direction = -1
            
            if LeapYearCounter > 0{
                LeapYearCounter -= 1
            }
            if LeapYearCounter == 0{
                DaysInMonths[1] = 29
                LeapYearCounter = 4
            }else{
                DaysInMonths[1] = 28
            }
            
            GetStartDateDayPosition()
            currentMonth = Months[month]
            
            MonthLabel.text = "\(currentMonth) \(year)"
            MoveAnimationBack(Label: MonthLabel)
            Calendar.reloadData()
            
        default:
            month -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            currentMonth = Months[month]
            
            MonthLabel.text = "\(currentMonth) \(year)"
            MoveAnimationBack(Label: MonthLabel)
            Calendar.reloadData()
        }
    }
    
    func GetStartDateDayPosition(){
        switch Direction{
        case 0:
            NumberOfEmptyBox = weekday
            dayCounter = day
            while dayCounter > 0{
                NumberOfEmptyBox = NumberOfEmptyBox - 1
                dayCounter = dayCounter - 1
                if NumberOfEmptyBox == 0{
                    NumberOfEmptyBox = 7
                }
            }
            if NumberOfEmptyBox == 7 {
                NumberOfEmptyBox = 0
            }
            PositionIndex = NumberOfEmptyBox
            
        case 1...:
            NextNumberOfEmptyBox = (PositionIndex + DaysInMonths[month])%7
            PositionIndex = NextNumberOfEmptyBox
            
        case -1:
            PreviousNumberOfEmptyBox = (7 - (DaysInMonths[month] - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7{
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Direction{
        case 0:
            return DaysInMonths[month] + NumberOfEmptyBox
        case 1...:
            return DaysInMonths[month] + NextNumberOfEmptyBox
        case -1:
            return DaysInMonths[month] + PreviousNumberOfEmptyBox
        default:
            fatalError()
        }
    }

    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DateCollectionViewCell
        cell.backgroundColor = UIColor.clear
        
        cell.DateLabel.textColor = UIColor.black
        cell.Circle.isHidden = true
        
        if cell.isHidden{
            cell.isHidden = false
        }
        
        switch Direction{
        case 0:
            cell.DateLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
        case 1:
            cell.DateLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
        case -1:
            cell.DateLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
        default:
            fatalError()
        }
        
        if Int(cell.DateLabel.text!)! < 1 {//hide every cell if is smaller than 1
            cell.isHidden = true
        }
        
        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34://the indexes of the collectionview that matches with the weekend days in every month
            if Int(cell.DateLabel.text!)! > 0 {
                cell.DateLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        //marks red the cell that shows the current date
        if currentMonth == Months[calendar.component(.month, from: date) - 1] && year == calendar.component(.year, from: date) && indexPath.row + 1 == day{
            //cell.backgroundColor =  UIColor.lightGray
            cell.Circle.isHidden = false
            cell.DrawCircle()
        }
        cellsArray.append(cell)
        if hDate == indexPath.row{
            cell.backgroundColor = UIColor.blue
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.layer.transform = CATransform3DMakeScale(0.5, 0.5, 0.5)
        
        for x in cellsArray{
            let cell: UICollectionViewCell = x
            
            UIView.animate(withDuration: 1, delay: 0.01 * Double(indexPath.row), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                cell.alpha = 1
                cell.layer.transform = CATransform3DMakeScale(1, 1, 1)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dateString = "\(indexPath.row - PositionIndex + 1) \(currentMonth) \(year)"
        print(dateString)
        performSegue(withIdentifier: "NextView", sender: self)
        //print(indexPath.row)
        hDate = indexPath.row
        collectionView.reloadData()
        
    }


}

