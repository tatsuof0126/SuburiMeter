//
//  SuburiMeterView.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/02/13.
//

import UIKit

class SuburiMeterView: UIView {
    
    var suburiCount:Int = 0
    var startCount:Int = 0
    var goalCount:Int = 1000
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        backgroundColor = UIColor.white
        
        drawMeter()
    }
    
    func drawMeter(){
        let count = suburiCount - startCount
        let range = goalCount - startCount
        
        var height = 0
        if range > 0 {
            height = Int(count * 300 / range)
            if(height > 300){
                height = 300
            }
        }
        
        if(height >= 1){
            let suburiRect = UIBezierPath(rect: CGRect(x: 150, y: 330-height, width: 70, height: height))
            suburiRect.lineWidth = 2
            UIColor.blue.setStroke()
            UIColor.cyan.setFill()
            suburiRect.stroke()
            suburiRect.fill()
        }
        
        let startline = UIBezierPath();
        UIColor.black.setStroke()
        startline.lineWidth = 2
        startline.move(to: CGPoint(x: 120, y: 330));
        startline.addLine(to: CGPoint(x: 250, y: 330));
        startline.close()
        startline.stroke();
        
        let goalline = UIBezierPath();
        UIColor.black.setStroke()
        goalline.lineWidth = 2
        goalline.move(to: CGPoint(x: 120, y: 30));
        goalline.addLine(to: CGPoint(x: 250, y: 30));
        goalline.close()
        goalline.stroke();
        
        let startStr = "\(startCount)回"
        let goalStr = "\(goalCount)回"
        let startXadj = startStr.count * 10
        let goalXadj = goalStr.count * 10
        
        startStr.draw(at: CGPoint(x: 90-startXadj, y: 318), withAttributes: [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
        ])
        goalStr.draw(at: CGPoint(x: 90-goalXadj, y: 19), withAttributes: [
            NSAttributedString.Key.foregroundColor : UIColor.black,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18),
        ])

    }
    
}


