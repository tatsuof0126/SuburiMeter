//
//  SuburiResult+CoreDataClass.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/01/17.
//

import Foundation
import CoreData
 
@objc(SuburiResult)
public class SuburiResult: NSManagedObject {
    
    func getDateNSAttributedString() -> NSAttributedString {
        return NSAttributedString(string: SuburiResult.getDateString(self.date!))
    }

    static func getDateString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M月d日(E) H:mm"
        return dateFormatter.string(from: date)
    }
 
}
