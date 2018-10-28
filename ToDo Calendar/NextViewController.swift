
import UIKit

class NextViewController: UIViewController {
    @IBOutlet var DateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DateLabel.text = dateString

        // Do any additional setup after loading the view.
    }

}
