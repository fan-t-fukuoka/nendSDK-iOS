//
//  NativeAdCollectionViewController.swift
//  NendSDK_Sample
//
//  Copyright © 2015年 F@N Communications. All rights reserved.
//

import UIKit

class NativeAdCollectionViewController: UICollectionViewController {
    
    private var ads = [NADNative]()
    private var stopAdLoad = false
    private let adInterval = 10
    private let itemCount = 100
    private let client = NADNativeClient(spotId: "485502", apiKey: "a3972604a76864dd110d0b02204f4b72adb092ae", advertisingExplicitly: .AD)
    private let colors = [UIColor.redColor(), UIColor.blueColor(), UIColor.yellowColor(), UIColor.greenColor(), UIColor.purpleColor(), UIColor.orangeColor()]

    deinit {
        print("NativeAdCollectionViewController: deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes

        // Do any additional setup after loading the view.
        
        self.title = "Collection"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount + itemCount / adInterval
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if self.isAdRow(indexPath.row) {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AdCell", forIndexPath: indexPath) as! NativeAdCollectionView
            if !self.stopAdLoad {
                self.client.loadWithCompletionBlock({ (ad, error) -> Void in
                    if let nativeAd = ad {
                        self.ads.append(nativeAd)
                        nativeAd.intoView(cell)
                    } else {
                        if kNADNativeErrorCodeExcessiveAdCalls == error.code {
                            // 広告の取得限界に達した場合は追加でロードを行わない
                            self.stopAdLoad = true
                        }
                        self.adFromCache(indexPath).intoView(cell)
                    }
                })
            } else {
                // 広告の取得限界に達している場合は取得済みの広告を表示させる
                self.adFromCache(indexPath).intoView(cell)
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
            cell.contentView.backgroundColor = self.colors[(indexPath.row - indexPath.row / adInterval) % self.colors.count]
            return cell
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if !self.isAdRow(indexPath.row) {
            print("Click normal cell.")
        }
    }
    
    // MARK: Private
    
    private func isAdRow(row: Int) -> Bool {
        return 0 != row && 0 == row % adInterval
    }
    
    private func adFromCache(indexPath: NSIndexPath) -> NADNative {
        let pos = (indexPath.row / adInterval - 1) % self.ads.count
        return self.ads[pos]
    }
}
