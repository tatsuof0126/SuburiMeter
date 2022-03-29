//
//  Utility.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/01/16.
//

import UIKit

class Utility {
    
    static func showAlert(controller: UIViewController, title: String, message: String) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default, handler:nil))
        
        controller.present(alert, animated: true, completion: nil)
    }
    
    static func showConfirmDialog(controller: UIViewController,
                                  title: String, message: String, handler: ((UIAlertAction)->Void)?) {
        let alert = UIAlertController(title:title, message:message, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default, handler: handler))
        alert.addAction(UIAlertAction(title: "キャンセル",
                                      style: UIAlertAction.Style.cancel))
        
        controller.present(alert, animated: true, completion: nil)
    }
 
    static func nextlineToSpace(orgString: String) -> String {
        return orgString.replacingOccurrences(of: "\r\n|\n", with: " ", options: NSString.CompareOptions.regularExpression, range: nil)
    }

}

