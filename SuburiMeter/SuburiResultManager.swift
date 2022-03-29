//
//  SuburiResultManager.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/01/16.
//

import UIKit
import CoreData

class SuburiResultManager {
    private static var persistentContainer: NSPersistentContainer! = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    static func createSuburiResult() -> SuburiResult {
        let context = persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "SuburiResult", in: context)!
        let suburiResult = SuburiResult(entity: entity, insertInto: nil)
        suburiResult.uuid = ""
        suburiResult.date = Date()
        suburiResult.memo = ""
        
        return suburiResult
    }
    
    
    static func saveSuburiResult(_ suburiResult: SuburiResult) {
        let context = persistentContainer.viewContext
        context.insert(suburiResult)
        saveContext()
    }
    
    static func deleteSuburiResult(_ suburiResult: SuburiResult) {
        let context = persistentContainer.viewContext
        context.delete(suburiResult)
        saveContext()
    }
    
    static func getAllSuburiResult() -> [SuburiResult] {
        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SuburiResult")
        
        let sortDescripter = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sortDescripter]
        
        do {
            let suburiResultList = try context.fetch(request) as! [SuburiResult]
            return suburiResultList
        }
        catch {
            fatalError()
        }
    }
    
    /*
    static func getSuburiResult(onlyAfter birthday: Date) -> [Person] {
        let predicate = NSPredicate(format: "birthday >= %@", birthday as NSDate)
        return getPersons(with: predicate)
    }

    static func getPersons(with predicate: NSPredicate?) -> [Person] {

        let context = persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Person")
        request.predicate = predicate
        
        do {
            let persons = try context.fetch(request) as! [Person]
            return persons
        }
        catch {
            fatalError()
        }
    }
     */
    
    static func saveContext() {
        let context = persistentContainer.viewContext
        // context.mergePolicy = NSOverwriteMergePolicy
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    static func makeTestData() {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = SuburiResult.entity()
        let SuburiResultList = try? context.fetch(fetchRequest) as? [SuburiResult]
        for suburiResult in SuburiResultList! {
            context.delete(suburiResult)
        }
        
        let testSuburiResultList: [[String]] = [
            ["2021/9/20 20:00:00", "120"],
            ["2021/9/21 20:00:00", "200"],
            ["2021/9/22 20:00:00", "105"],
            ["2021/9/23 20:00:00", "30"],
            ["2021/9/24 20:00:00", "80"],
            ["2021/9/28 20:00:00", "60"],
            ["2021/9/29 20:00:00", "50"],
            ["2021/9/30 20:00:00", "110"],
            
            ["2021/10/01 20:00:00", "80"],
            ["2021/10/04 20:00:00", "80"],
            ["2021/10/05 20:00:00", "190"],
            ["2021/10/06 20:00:00", "220"],
            ["2021/10/07 20:00:00", "125"],
            ["2021/10/08 20:00:00", "140"],
            ["2021/10/10 20:00:00", "80"],
            ["2021/10/11 20:00:00", "100"],
            ["2021/10/12 20:00:00", "60"],
            ["2021/10/14 20:00:00", "70"],
            ["2021/10/15 20:00:00", "70"],
            ["2021/10/17 20:00:00", "51"],
            ["2021/10/18 20:00:00", "79"],
            ["2021/10/20 20:00:00", "50"],
            ["2021/10/25 20:00:00", "70"],
            ["2021/10/26 20:00:00", "70"],
            ["2021/10/28 20:00:00", "70"],
            ["2021/10/29 20:00:00", "100"],
            
            ["2021/11/01 20:00:00", "100"],
            ["2021/11/02 20:00:00", "60"],
            ["2021/11/04 20:00:00", "70"],
            ["2021/11/05 20:00:00", "110"],
            ["2021/11/08 20:00:00", "90"],
            ["2021/11/09 20:00:00", "70"],
            ["2021/11/10 20:00:00", "30"],
            ["2021/11/11 20:00:00", "70"],
            ["2021/11/15 20:00:00", "35"],
            ["2021/11/16 20:00:00", "35"],
            ["2021/11/17 20:00:00", "50"],
            ["2021/11/18 20:00:00", "70"],
            ["2021/11/19 20:00:00", "70"],
            ["2021/11/22 20:00:00", "200"],
            ["2021/11/24 20:00:00", "70"],
            ["2021/11/25 20:00:00", "30"],
            ["2021/11/26 20:00:00", "70"],
            ["2021/11/29 20:00:00", "60"],
            ["2021/11/30 20:00:00", "70"],
            
            ["2021/12/01 20:00:00", "40"],
            ["2021/12/02 20:00:00", "70"],
            ["2021/12/03 20:00:00", "40"],
            ["2021/12/06 20:00:00", "30"],
            ["2021/12/08 20:00:00", "50"],
            ["2021/12/09 20:00:00", "70"],
            ["2021/12/10 20:00:00", "50"],
            ["2021/12/13 20:00:00", "50"],
            ["2021/12/14 20:00:00", "60"],
            ["2021/12/15 20:00:00", "60"],
            ["2021/12/16 20:00:00", "50"],
            ["2021/12/20 20:00:00", "35"],
            ["2021/12/21 20:00:00", "30"],
            ["2021/12/22 20:00:00", "30"],
            ["2021/12/24 20:00:00", "1500"],
            ["2021/12/27 20:00:00", "55"],
            
            ["2022/04/01 20:49:00", "70"],
            ["2022/04/02 15:48:00", "100"],
            ["2022/04/03 18:49:00", "100"],
            ["2022/04/07 21:46:00", "90"],
            ["2022/04/08 20:31:00", "250"],
            ["2022/04/09 21:20:00", "100"],
            ["2022/04/10 21:34:00", "100"],
            ["2022/04/11 21:42:00", "120"],
            ["2022/04/13 16:13:00", "50"],
            ["2022/04/14 21:23:00", "100"],
            ["2022/04/15 17:31:00", "200"],
            ["2022/04/16 21:29:00", "50"],
            ["2022/04/17 21:29:00", "100"],
            ["2022/04/18 21:29:00", "110"]
        ]

        
        /*
        let testSuburiResultList: [[String]] = [
            ["2021/9/20 20:00:00", "120"],
            ["2021/9/21 20:00:00", "200"],
            ["2021/9/22 20:00:00", "105"],
            ["2021/9/23 20:00:00", "30"],
            ["2021/9/24 20:00:00", "80"],
            ["2021/9/28 20:00:00", "60"],
            ["2021/9/29 20:00:00", "50"],
            ["2021/9/30 20:00:00", "110"],
            
            ["2021/10/01 20:00:00", "80"],
            ["2021/10/04 20:00:00", "80"],
            ["2021/10/05 20:00:00", "190"],
            ["2021/10/06 20:00:00", "220"],
            ["2021/10/07 20:00:00", "125"],
            ["2021/10/08 20:00:00", "140"],
            ["2021/10/10 20:00:00", "80"],
            ["2021/10/11 20:00:00", "100"],
            ["2021/10/12 20:00:00", "60"],
            ["2021/10/14 20:00:00", "70"],
            ["2021/10/15 20:00:00", "70"],
            ["2021/10/17 20:00:00", "51"],
            ["2021/10/18 20:00:00", "79"],
            ["2021/10/20 20:00:00", "50"],
            ["2021/10/25 20:00:00", "70"],
            ["2021/10/26 20:00:00", "70"],
            ["2021/10/28 20:00:00", "70"],
            ["2021/10/29 20:00:00", "100"],
            
            ["2021/11/01 20:00:00", "100"],
            ["2021/11/02 20:00:00", "60"],
            ["2021/11/04 20:00:00", "70"],
            ["2021/11/05 20:00:00", "110"],
            ["2021/11/08 20:00:00", "90"],
            ["2021/11/09 20:00:00", "70"],
            ["2021/11/10 20:00:00", "30"],
            ["2021/11/11 20:00:00", "70"],
            ["2021/11/15 20:00:00", "35"],
            ["2021/11/16 20:00:00", "35"],
            ["2021/11/17 20:00:00", "50"],
            ["2021/11/18 20:00:00", "70"],
            ["2021/11/19 20:00:00", "70"],
            ["2021/11/22 20:00:00", "200"],
            ["2021/11/24 20:00:00", "70"],
            ["2021/11/25 20:00:00", "30"],
            ["2021/11/26 20:00:00", "70"],
            ["2021/11/29 20:00:00", "60"],
            ["2021/11/30 20:00:00", "70"],
            
            ["2021/12/01 20:00:00", "40"],
            ["2021/12/02 20:00:00", "70"],
            ["2021/12/03 20:00:00", "40"],
            ["2021/12/06 20:00:00", "30"],
            ["2021/12/08 20:00:00", "50"],
            ["2021/12/09 20:00:00", "70"],
            ["2021/12/10 20:00:00", "50"],
            ["2021/12/13 20:00:00", "50"],
            ["2021/12/14 20:00:00", "60"],
            ["2021/12/15 20:00:00", "60"],
            ["2021/12/16 20:00:00", "50"],
            ["2021/12/20 20:00:00", "35"],
            ["2021/12/21 20:00:00", "30"],
            ["2021/12/22 20:00:00", "30"],
            ["2021/12/24 20:00:00", "100"],
            ["2021/12/27 20:00:00", "50"],
            
            ["2022/01/04 20:00:00", "175"],
            ["2022/01/05 20:00:00", "40"],
            ["2022/01/07 20:00:00", "30"],
            ["2022/01/11 20:00:00", "30"],
            ["2022/01/12 20:00:00", "50"],
            ["2022/01/13 20:00:00", "220"],
            ["2022/01/14 20:00:00", "70"],
            ["2022/01/17 20:00:00", "70"],
            ["2022/01/18 20:00:00", "180"],
            ["2022/01/19 20:00:00", "50"],
            ["2022/01/20 20:00:00", "50"],
            ["2022/01/21 20:00:00", "30"],
            ["2022/01/24 20:00:00", "80"],
            ["2022/01/25 20:00:00", "30"],
            ["2022/01/26 20:00:00", "110"],
            ["2022/01/27 20:00:00", "100"],
            ["2022/01/28 20:00:00", "150"],
            ["2022/01/29 20:00:00", "100"],
            ["2022/01/31 20:00:00", "10"],
            
            ["2022/02/02 20:00:00", "120"],
            ["2022/02/03 20:00:00", "110"],
            ["2022/02/04 20:00:00", "100"],
            ["2022/02/05 20:00:00", "50"],
            ["2022/02/07 20:00:00", "110"],
            ["2022/02/08 20:00:00", "320"],
            ["2022/02/09 20:00:00", "110"],
            ["2022/02/11 20:00:00", "100"],
            ["2022/02/14 20:23:00", "100"],
            ["2022/02/15 17:07:00", "100"],
            ["2022/02/16 17:05:00", "120"],
            ["2022/02/17 19:08:00", "270"],
            ["2022/02/18 21:18:00", "130"],
            ["2022/02/19 08:39:00", "50"],
            ["2022/02/21 19:06:00", "100"],
            ["2022/02/22 17:54:00", "150"],
            ["2022/02/24 18:52:00", "60"],
            ["2022/02/25 21:14:00", "50"],
            ["2022/02/26 17:22:00", "90"],
            ["2022/02/28 21:25:00", "150"],
            
            ["2022/03/01 20:49:00", "70"],
            ["2022/03/02 15:48:00", "130"],
            ["2022/03/03 18:49:00", "110"],
            ["2022/03/07 21:46:00", "90"],
            ["2022/03/08 20:31:00", "130"],
            ["2022/03/09 21:20:00", "100"],
            ["2022/03/10 21:34:00", "100"],
            ["2022/03/11 21:42:00", "120"],
            ["2022/03/13 16:13:00", "30"],
            ["2022/03/14 21:23:00", "121"],
            ["2022/03/15 17:31:00", "100"],
            ["2022/03/16 21:29:00", "100"],
            ["2022/03/17 21:16:00", "110"],
            ["2022/03/22 20:59:00", "109"]
        ]
        */
         
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/M/d H:m:s"

        for testSuburiResult in testSuburiResultList {
            let suburiResult = SuburiResultManager.createSuburiResult()
            if let countInt = Int32(testSuburiResult[1]) {
                suburiResult.count = countInt
            }
            suburiResult.date = dateFormatter.date(from: testSuburiResult[0])
            // suburiResult.memo = memoText.text
            suburiResult.uuid = NSUUID().uuidString
            context.insert(suburiResult)
        }
        
        saveContext()
    }
    
}

