//
//  ConfigViewController.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/01/04.
//

import UIKit

class ConfigViewController: CommonViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var appStoreLabel: UILabel!
    
    @IBOutlet weak var goalCountText: UITextField!
    
    @IBOutlet weak var startCountText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let goalCount = ConfigManager.getGoalCount()
        let startCount = ConfigManager.getStartCount()
        
        goalCountText.text = "\(goalCount)"
        startCountText.text = "\(startCount)"
        
        goalCountText.delegate = self
        startCountText.delegate = self
        
        // アプリ名とバージョンの表示
        let version: String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        versionLabel.text = "素振りメーター" + " Ver" + version!
        
        // 他のアプリへのリンク
        let tapGestureRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(ConfigViewController.onLinkTap(_:)))
        appStoreLabel.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.delegate = self
        
        loadBannerView()
    }
    
    @objc func onLinkTap(_ sender: UITapGestureRecognizer){
        let itunesURL:String = "itms-apps://itunes.apple.com/developer/tatsuo-fujiwara/id578136106"
        let url = URL(string:itunesURL)
        UIApplication.shared.open(url!, completionHandler: { (success) in })
    }
    
    func textFieldDidEndEditing(_ textField:UITextField){
        if(textField == startCountText){
            if let countInt = Int(startCountText.text!) {
                if countInt >= 0 {
                    ConfigManager.setStartCount(count: countInt)
                }
            }
        } else if(textField == goalCountText){
            if let countInt = Int(goalCountText.text!) {
                if countInt > 0 {
                    ConfigManager.setGoalCount(count: countInt)
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
