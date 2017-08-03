//
//  PublicView.m
//  SPAlbum
//
//  Created by Mac on 2017/6/2.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "PublicView.h"
#import "MBProgressHUD+KR.h"
#import "DataManagerTool.h"
@implementation PublicView
- (IBAction)ok:(id)sender {
    if (_kindNameTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入分组名"];
        return;
    }
    if (![[DataManagerTool sharedDataManagetTool] judgemetAlbumPasswordIsRight:_passwordTF.text] && _passwordTF.text.length > 0) {
        [MBProgressHUD showError:@"请输入四位数字密码"];
        return;
    }
    NSString *password = _passwordTF.text.length>0 ? _passwordTF.text : @"";
    _buttonClickBlock(1,_kindNameTF.text,password);
}
- (IBAction)cancelB:(id)sender {
    _buttonClickBlock(3,nil,nil);
}
- (IBAction)forgetPassword:(id)sender {
    _buttonClickBlock(1,nil,nil);
}
- (IBAction)gotoPhoto:(id)sender {
    _buttonClickBlock(2,nil,_password2.text);
}
- (IBAction)cancel:(id)sender {
    _buttonClickBlock(2,nil,nil);
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
