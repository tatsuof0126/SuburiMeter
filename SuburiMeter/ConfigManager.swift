//
//  ConfigManager.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/03/22.
//

import Foundation

class ConfigManager {
        
    static func isShowAds() -> Bool {
        if AppDelegate.SHOW_ADS == false {
            return false
        }
        
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: "SHOWADS") != nil) {
            return userDefaults.bool(forKey: "SHOWADS")
        }
        return true
    }
    
    static func setShowAds(showAds: Bool) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(showAds, forKey: "SHOWADS")
    }
    
    static func getStartCount() -> Int {
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: "STARTCOUNT") == nil) {
            setStartCount(count: 0)
        }
        
        return userDefaults.integer(forKey: "STARTCOUNT")
    }
    
    static func setStartCount(count: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(count, forKey: "STARTCOUNT")
    }
    
    static func getGoalCount() -> Int {
        let userDefaults = UserDefaults.standard
        if (userDefaults.object(forKey: "GOALCOUNT") == nil) {
            setGoalCount(count: 1000)
        }
        
        return userDefaults.integer(forKey: "GOALCOUNT")
    }
    
    static func setGoalCount(count: Int) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(count, forKey: "GOALCOUNT")
    }
    

}
