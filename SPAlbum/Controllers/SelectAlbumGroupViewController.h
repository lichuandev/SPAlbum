//
//  SelectAlbumGroupViewController.h
//  SPAlbum
//
//  Created by Mac on 2017/6/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectAlbumGroupViewController : UIViewController
@property (nonatomic, copy) void (^select)(NSString *kind);
@end
