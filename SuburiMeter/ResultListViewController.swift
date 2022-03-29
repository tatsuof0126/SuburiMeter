//
//  ResultListViewController.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/01/03.
//

import UIKit
import GoogleMobileAds
import MessageUI
import AppTrackingTransparency

class ResultListViewController: CommonViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!

    var suburiResultList: [SuburiResult]!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadBannerView()
    }
    
    override func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("subclass bannerViewDidReceiveAd")
        
        if bannerShowing == false {
            tableViewBottomConstraint.constant = -bannerView.frame.size.height
        }
        
        super.bannerViewDidReceiveAd(bannerView)
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "resultlistcell")
        
        let suburiResult = suburiResultList[indexPath.row]
        
        let labelStr = NSMutableAttributedString()
        labelStr.append(suburiResult.getDateNSAttributedString())
        labelStr.append(NSAttributedString(string: "  "))
        
        let countStr = "\(suburiResult.count)回"
        if(suburiResult.count >= 200){
            let attributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : UIColor.red,
                .font: UIFont.boldSystemFont(ofSize: 24)
            ]
            labelStr.append(NSAttributedString(string: countStr, attributes: attributes))
        } else if(suburiResult.count >= 100){
            let attributes: [NSAttributedString.Key : Any] = [
                .foregroundColor : UIColor.blue,
                .font: UIFont.boldSystemFont(ofSize: 24)
            ]
            labelStr.append(NSAttributedString(string: countStr, attributes: attributes))
        } else {
            let attributes: [NSAttributedString.Key : Any] = [
                .font: UIFont.systemFont(ofSize: 24)
            ]
            labelStr.append(NSAttributedString(string: countStr, attributes: attributes))
        }
        
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
        cell.textLabel?.attributedText = labelStr
        
        let detailLabelStr = NSMutableString()
        let memoStr = Utility.nextlineToSpace(orgString: suburiResult.memo!).trimmingCharacters(in: .whitespaces)
        if memoStr != "" {
            detailLabelStr.append(memoStr)
        }
        
        cell.detailTextLabel?.text = detailLabelStr as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if suburiResultList != nil {
            return suburiResultList.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath:IndexPath) {
        performSegue(withIdentifier: "updateresult", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "addresult") {
            let inputController = segue.destination as? ResultInputViewController
            inputController?.suburiResult = nil
        } else if segue.identifier == "updateresult" {
            let row = tableView.indexPathForSelectedRow!.row
            let suburiResult = suburiResultList[row]
            
            let inputController = segue.destination as? ResultInputViewController
            inputController?.suburiResult = suburiResult
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadSuburiResult()
        tableView.reloadData()
    }

    func loadSuburiResult() {
        suburiResultList = SuburiResultManager.getAllSuburiResult()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        let delegate = UIApplication.shared.delegate as! AppDelegate        
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
            
            // 記録を５件以上登録してたら一定割合でレビュー依頼
            if showed == false && suburiResultList.count >= 5 {
                AppDelegate.requestReview()
            }
        }
    }

}
