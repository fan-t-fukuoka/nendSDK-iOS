//
//  Ad300_100AdjustViewController.h
//  NendSDK_Sample
//
//  Created by ADN on 2013/07/19.
//  Copyright (c) 2013年 F@N Communications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"

@interface Ad300_100AdjustViewController : UIViewController<NADViewDelegate>{
    NADView* nadView;
}

@property(nonatomic,retain)NADView* nadView;


@end
