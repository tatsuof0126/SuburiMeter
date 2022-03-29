//
//  AppDelegate.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/01/03.
//

import UIKit
import CoreData
import Firebase
import IQKeyboardManagerSwift
import GoogleMobileAds
import AppTrackingTransparency
import UserMessagingPlatform
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, GADFullScreenContentDelegate {

    // 広告を非表示にするならfalse（リリース時はtrue）
    static let SHOW_ADS = true
    
    // テストデータ作成用（リリース時はfalse）
    static let MAKE_TEST_DATA = false
    
    // インタースティシャル広告の表示割合（％）
    static let SHOW_INTERSTITIAL_RATIO = 35
    
    // レビュー依頼ダイアログの表示割合（％）
    static let SHOW_REQUESTREVIEW_RATIO = 4
    
    var gadInterstitial: GADInterstitialAd!
    var showInterstitialFlag: Bool!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Firebase/Admobの初期化、インタースティシャルを準備しておく
        FirebaseApp.configure()
        IQKeyboardManager.shared.enable = true
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GADMobileAds.sharedInstance().applicationVolume = 0.01

        showInterstitialFlag = false
        loadInterstitial()
        
        if AppDelegate.MAKE_TEST_DATA == true {
            SuburiResultManager.makeTestData()
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "SuburiMeter")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
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

    func loadInterstitial() {
        if ConfigManager.isShowAds() == false {
            return
        }
        
        print("Load Interstitial")

        let request = GADRequest()
        // GADInterstitialAd.load(withAdUnitID:"ca-app-pub-3940256099942544/4411468910", // テスト用
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-6719193336347757/8775318928",
                                    request: request,
                          completionHandler: { [self] ad, error in
                            if let error = error {
                              print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                              return
                            }
                            gadInterstitial = ad
                            gadInterstitial?.fullScreenContentDelegate = self
                          }
        )
    }
    
    func showInterstitial(_ controller: UIViewController) -> Bool {
        showInterstitialFlag = false
        
        if(ConfigManager.isShowAds() == false){
            return false
        }
        
        let rand = (Int)(arc4random_uniform(100))
        print("rand : \(rand) show -> \(rand < AppDelegate.SHOW_INTERSTITIAL_RATIO)")
        if rand >= AppDelegate.SHOW_INTERSTITIAL_RATIO {
            return false
        }
        
        if gadInterstitial != nil {
            print("Show Interstitial")
            gadInterstitial.present(fromRootViewController: controller)
            return true
        } else {
            print("Cannot Show Interstitial")
            loadInterstitial()
            return false
        }
        
        /*
        if gadInterstitial.isReady {
            gadInterstitial?.present(fromRootViewController: controller)
            return true
        } else {
            prepareInterstitial()
            return false
        }
         */
    }
    
    /*
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        // print("interstitialDidDismissScreen")
        prepareInterstitial()
    }

    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("interstitialDidReceiveAd")
    }
    
    /// Tells the delegate an ad request failed.
    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("interstitial:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that an interstitial will be presented.
    func interstitialWillPresentScreen(_ ad: GADInterstitial) {
        // print("interstitialWillPresentScreen")
    }
    
    /// Tells the delegate the interstitial is to be animated off the screen.
    func interstitialWillDismissScreen(_ ad: GADInterstitial) {
        // print("interstitialWillDismissScreen")
    }
    
    /// Tells the delegate the interstitial had been animated off the screen.
//    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
//        print("interstitialDidDismissScreen")
//    }
    
    /// Tells the delegate that a user click will open another app
    /// (such as the App Store), backgrounding the current app.
    func interstitialWillLeaveApplication(_ ad: GADInterstitial) {
        // print("interstitialWillLeaveApplication")
    }
    */
    
    
    // Tells the delegate that the ad failed to present full screen content.
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
      print("Ad did fail to present full screen content.")
        loadInterstitial()
    }

    // Tells the delegate that the ad presented full screen content.
    func adDidPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did present full screen content.")
    }

    // Tells the delegate that the ad dismissed full screen content.
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
      print("Ad did dismiss full screen content.")
        loadInterstitial()
    }
    
    
    static func requestReview() {
        let rand = (Int)(arc4random_uniform(100))
        // print("rand : \(rand) show -> \(rand < SHOW_REQUESTREVIEW_RATIO)")
        if rand >= AppDelegate.SHOW_REQUESTREVIEW_RATIO {
            return
        }
        
        if #available(iOS 14, *) {
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    func showATTDialog(_ controller: CommonViewController) {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization (
                completionHandler: { status in
                switch status {
                case .authorized:
                    print("ATTrackingManager authorized")
                    controller.reloadBannerView()
                    self.loadInterstitial()
                case .denied, .restricted, .notDetermined:
                    print("ATTrackingManager not authorized")
                @unknown default:
                    fatalError()
                }
            })
        }
    }
    
}

