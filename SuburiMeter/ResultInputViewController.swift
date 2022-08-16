//
//  ResultInputViewController.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/01/03.
//

import UIKit
import GoogleMobileAds

class ResultInputViewController: CommonViewController {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var countText: UITextField!
    @IBOutlet weak var memoText: UITextView!
    
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBOutlet weak var pickerBaseView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!

    // var bannerView: GADBannerView!
    
    var suburiResult: SuburiResult!
    var suburiDate: Date!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if suburiResult == nil {
            suburiResult = SuburiResultManager.createSuburiResult()
        }
        
        suburiDate = suburiResult.date
        setSuburiDate()
        
        if suburiResult.uuid != "" {
            countText.text = String(suburiResult.count)
        } else {
            // 新規の場合はデフォルトで回数にフォーカス
            countText.becomeFirstResponder()
            deleteBtn.isHidden = true
        }
        
        // メモTextViewを整形
        memoText.layer.borderWidth = 1
        memoText.layer.borderColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0).cgColor
        memoText.layer.cornerRadius = 8
                
        pickerBaseView.isHidden = true

        memoText.text = suburiResult.memo

        
        
        // テストコード
        // let suburiResultList = SuburiResultManager.getAllSuburiResult()
        // print("SuburiResult count : \(suburiResultList.count)")
        
        loadBannerView()
    }

    func setSuburiDate() {
        //let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "ja_JP")
        //dateFormatter.dateFormat = "M月d日(E) H:mm"
        //dateLabel.text = dateFormatter.string(from: suburiDate)
        dateLabel.text = SuburiResult.getDateString(suburiDate)
    }
    
    @IBAction func dateChangeButton(_ sender: Any) {
        showDatePicker()
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func deleteButton(_ sender: Any) {
        let handler = {(action: UIAlertAction) -> Void in
            let delegate = UIApplication.shared.delegate as! AppDelegate
            delegate.showInterstitialFlag = true

            self.deleteResult()
        }
        Utility.showConfirmDialog(controller: self, title: "", message: "記録を削除します。よろしいですか？", handler: handler)
    }
    
    func deleteResult(){
        SuburiResultManager.deleteSuburiResult(suburiResult)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let message = inputCheck()
        if(message.count != 0){
            Utility.showAlert(controller: self, title: "", message: message[0])
            return
        }
        
        if let countInt = Int32(countText.text!) {
            suburiResult.count = countInt
        }
        suburiResult.date = suburiDate
        suburiResult.memo = memoText.text
        if suburiResult.uuid == "" {
            suburiResult.uuid = NSUUID().uuidString
        }
        
        SuburiResultManager.saveSuburiResult(suburiResult)
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        delegate.showInterstitialFlag = true
        
        dismiss(animated: true, completion: nil)
    }
    
    func inputCheck() -> [String] {
        var message:[String] = []
        
        if let countInt = Int32(countText.text!) {
            if countInt < 0 {
                message.append("回数の値が正しくありません")
            }
        } else {
            message.append("回数の値が正しくありません")
        }
        
        return message
    }
    
    func endEditing() {
        self.view.endEditing(true)
    }
    
    func showDatePicker() {
        // 現在の編集を終わらせる
        endEditing()
        closePicker()
        
        // 広告ビューを隠す
        // if bannerView != nil {
        //     bannerView.isHidden = true
        // }
        
        // 昔のPicker形式（.wheels）
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = suburiDate
        
        // ピッカーをアニメーションで表示
        pickerBaseView.isHidden = false
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
            self.pickerBaseView.frame = CGRect(x: self.pickerBaseView.frame.origin.x,
                                          y: self.pickerBaseView.frame.origin.y-self.pickerBaseView.frame.size.height,
                                          width: self.pickerBaseView.frame.size.width,
                                          height: self.pickerBaseView.frame.size.height)
        }, completion: nil)
        
    }
    
    func closePicker() {
        pickerBaseView.isHidden = true
        pickerBaseView.frame = CGRect(x: self.pickerBaseView.frame.origin.x,
                                        y: self.view.frame.size.height,
                                        width: self.pickerBaseView.frame.size.width,
                                        height: self.pickerBaseView.frame.size.height)
        
        // 広告ビューを復活
        // if bannerView != nil {
        //     bannerView.isHidden = false
        // }
    }
    
    @IBAction func pickerDoneButton(_ sender: Any) {
        suburiDate = datePicker.date
        setSuburiDate()
        closePicker()
    }
    
    @IBAction func pickerCancelButton(_ sender: Any) {
        closePicker()
    }
    
}
