//
//  MeterViewController.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/01/03.
//

import UIKit
import GoogleMobileAds
import MessageUI
import AppTrackingTransparency

class MeterViewController: CommonViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var meterView: SuburiMeterView!

    var suburiResultList: [SuburiResult]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadBannerView()
        
    }

    func showCount(){
        suburiResultList = SuburiResultManager.getAllSuburiResult()
        var count:Int32 = 0
        for suburiResult in suburiResultList {
            count += suburiResult.count
        }
        
        let dateStr = "すべて"
        let countStr = "\(count)回"
        
        dateLabel.text = dateStr
        countLabel.text = countStr
        
        meterView.suburiCount = Int(count)
        meterView.startCount = ConfigManager.getStartCount()
        meterView.goalCount = ConfigManager.getGoalCount()
        meterView.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        showCount()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        
        // 指定日付以前だったらIDFAを求めるダイアログを出す
        if #available(iOS 14.5, *) {
            let today : Date = Date()
            let targetDate = Calendar(identifier: .gregorian).date(
                from: DateComponents(year: 2022, month: 3, day: 29))!
            
            if today < targetDate && ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                delegate.showATTDialog(self)
            }
        }
        
        if delegate.showInterstitialFlag {
            var showed = false
            // 記録を４件以上登録していたら一定割合でインタースティシャル広告
            if suburiResultList.count >= 4 {
                showed = delegate.showInterstitial(self)
            }
            
            // 記録を３件以上登録していたらIDFAを求めるダイアログを出す
            if #available(iOS 14.5, *) {
                if showed == false && suburiResultList.count >= 3 &&
                    ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                    delegate.showATTDialog(self)
                    showed = true
                }
            }
            
            // インタースティシャル非表示で記録を５件以上登録してたら一定割合でレビュー依頼
            if showed == false && suburiResultList.count >= 5 {
                AppDelegate.requestReview()
            }
        }
    }
}
