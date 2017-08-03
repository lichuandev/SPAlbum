//
//  PublicView.h
//  SPAlbum
//
//  Created by Mac on 2017/6/2.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublicView : UIView
@property (weak, nonatomic) IBOutlet UITextField *kindNameTF;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *fogetB;
@property (weak, nonatomic) IBOutlet UITextField *password2;
@property (weak, nonatomic) IBOutlet UIView *setView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (nonatomic, copy) void (^buttonClickBlock)(int index, NSString *name, NSString *password);
//@property (nonatomic, assign) int type; //type 1代表是修改相片名字
@end
