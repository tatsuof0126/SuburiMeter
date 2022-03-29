//
//  CommonViewController.swift
//  SuburiMeter
//
//  Created by Tatsuo Fujiwara on 2022/02/14.
//

import UIKit
import GoogleMobileAds

class CommonViewController: UIViewController, GADBannerViewDelegate {
    
    var bannerView: GADBannerView!
    var bannerShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

    }

    func loadBannerView(){
        if ConfigManager.isShowAds() == false {
            return
        }
        
        let frame = view.frame.inset(by: view.safeAreaInsets)
        let viewWidth = frame.size.width
        
        bannerView = GADBannerView()
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
        
        addBannerViewToView(bannerView)
        
        bannerView.adUnitID = "ca-app-pub-6719193336347757/2593053958"
        // bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716" // テスト用
        bannerView.rootViewController = self
        bannerView.delegate = self
        bannerView.load(GADRequest())
    }
    
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(bannerView)
        view.addConstraints(
             [NSLayoutConstraint(item: bannerView,
                            attribute: .centerX,
                            relatedBy: .equal,
                            toItem: view,
                            attribute: .centerX,
                            multiplier: 1,
                            constant: 0)
            ])
        bannerView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:0).isActive = true
     }

    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        bannerShowing = true
        print("bannerViewDidReceiveAd")
    }
    
    func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("bannerView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }

    func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
        print("bannerViewDidRecordImpression")
    }

    func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillPresentScreen")
    }

    func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewWillDIsmissScreen")
    }

    func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("bannerViewDidDismissScreen")
    }
    
    func reloadBannerView(){
        if ConfigManager.isShowAds() == false {
            return
        }
                
        let gadRequest: GADRequest = GADRequest()
        bannerView.load(gadRequest)
    }
        
}
