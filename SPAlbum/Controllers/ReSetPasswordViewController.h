//
//  ReSetPasswordViewController.h
//  SPAlbum
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoKind.h"
@interface ReSetPasswordViewController : UIViewController
@property (nonatomic, assign) int type; // type 1 代表是相册密码
@property (nonatomic, strong) PhotoKind *kind;
@end
