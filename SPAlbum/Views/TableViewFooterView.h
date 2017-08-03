//
//  TableViewFooterView.h
//  SPAlbum
//
//  Created by Mac on 2017/6/2.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol tableViewFooterViewDelegate
-(void)addKinds;
@end
@interface TableViewFooterView : UIView
@property (nonatomic, weak)id<tableViewFooterViewDelegate>delegate;
@end
