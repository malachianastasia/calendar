
import UIKit

class DateCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var Circle: UIView!
    @IBOutlet weak var DateLabel: UILabel!
    
    func DrawCircle(){
        let circleCenter = Circle.center;
        
        let circlePath = UIBezierPath(arcCenter: circleCenter, radius: (Circle.bounds.width/2 - 5), startAngle: 0, endAngle: 2 * CGFloat.pi, clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 2
        circleLayer.strokeEnd = 0
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = kCALineCapRound
        
        let Animation = CABasicAnimation(keyPath: "strokeEnd")
        Animation.duration = 1
        Animation.toValue = 1
        Animation.fillMode = kCAFillModeForwards
        Animation.isRemovedOnCompletion = false
        
        circleLayer.add(Animation, forKey: nil)
        Circle.layer.addSublayer(circleLayer)
        Circle.layer.backgroundColor = UIColor.clear.cgColor
        
    }
}
