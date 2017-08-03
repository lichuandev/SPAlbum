//
//  ReSetPasswordViewController.m
//  SPAlbum
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "ReSetPasswordViewController.h"
#import "DataManagerTool.h"
#import "GroupingViewController.h"
#import "DBManagerTool.h"
#import "MBProgressHUD+KR.h"
@interface ReSetPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *ReSetPassword;
@property (weak, nonatomic) IBOutlet UITextField *ReSetPassword2;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImagev;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageV2;
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UITextField *simiReSetTF;
@property (weak, nonatomic) IBOutlet UITextField *simiReSet2;
@property (weak, nonatomic) IBOutlet UIImageView *simiImagev;
@property (weak, nonatomic) IBOutlet UIImageView *simiImageV2;
@property (weak, nonatomic) IBOutlet UIView *simiView;

@property (nonatomic, assign) int isSimi;

@end

@implementation ReSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"重置密码";
    _isSimi = [[DataManagerTool sharedDataManagetTool]getIsSimi];
    if (_type == 1) {
        _ReSetPassword.placeholder = @"四位数字";
        _ReSetPassword2.placeholder = @"四位数字";
        _simiView.hidden = YES;
    }else{
        self.okButton.enabled = YES;
    }
}
- (IBAction)reSetPassword:(id)sender {
    _passwordImagev.hidden = _ReSetPassword.text.length == 0 ? YES : NO;
    BOOL result;
    if (_type == 1) {
        result = [[DataManagerTool sharedDataManagetTool] judgemetAlbumPasswordIsRight:_ReSetPassword.text];
    }else{
        result = [[DataManagerTool sharedDataManagetTool] judgemetPasswordIsRight:_ReSetPassword.text];
    }
    
    if (result) {
        _passwordImagev.image = [UIImage imageNamed:@"answer_right"];
    }else{
        _passwordImagev.image = [UIImage imageNamed:@"answer_error"];
    }
    if (_type == 1) {
        [self canLogin];
    }
    
}
- (IBAction)reSetPassword2:(id)sender {
    _passwordImageV2.hidden = _ReSetPassword2.text.length == 0 ? YES : NO;
    if ([_ReSetPassword.text isEqualToString:_ReSetPassword2.text]) {
        _passwordImageV2.image = [UIImage imageNamed:@"answer_right"];
    }else{
        _passwordImageV2.image = [UIImage imageNamed:@"answer_error"];
    }
    if (_type == 1) {
        [self canLogin];
    }
}
- (IBAction)simiReset:(UITextField *)sender {
    _simiImagev.hidden = _simiReSetTF.text.length == 0 ? YES : NO;
    bool result = [[DataManagerTool sharedDataManagetTool] judgemetPasswordIsRight:_simiReSetTF.text];
    if (result) {
        _simiImagev.image = [UIImage imageNamed:@"answer_right"];
    }else{
        _simiImagev.image = [UIImage imageNamed:@"answer_error"];
    }
}
- (IBAction)simiReset2:(UITextField *)sender {
    _simiImageV2.hidden = _simiReSet2.text.length == 0 ? YES : NO;
    if ([_simiReSet2.text isEqualToString:_simiReSetTF.text]) {
        _simiImageV2.image = [UIImage imageNamed:@"answer_right"];
    }else{
        _simiImageV2.image = [UIImage imageNamed:@"answer_error"];
    }
}

- (IBAction)reSet:(id)sender {
    if (_type == 1) {
        [DBManagerTool editPhotoKindPassword:_ReSetPassword.text oldName:_kind.password type:_isSimi];
        _kind.password = _ReSetPassword.text;
        
        
    }else{
        if (_ReSetPassword.text.length == 0 && _simiReSetTF.text.length == 0) {
            [MBProgressHUD showError:@"请输入要修改的密码"];
            return;
        }
        NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"myPassword"];
        NSString *simi = dic[@"simiPassword"];
        NSString *noSimi = dic[@"password"];
        if ([_ReSetPassword.text isEqualToString:_ReSetPassword2.text] || (simi.length>0 && [simi isEqualToString:_ReSetPassword.text]) || (noSimi.length>0 && [noSimi isEqualToString:_simiReSetTF.text])) {
            [MBProgressHUD showError:@"普通密码与私密密码不能相同"];
            return;
        }
        
        if (_ReSetPassword.text.length>0) {
            if ([[DataManagerTool sharedDataManagetTool]judgemetPasswordIsRight:_ReSetPassword.text] && [_ReSetPassword2.text isEqualToString:_ReSetPassword.text]) {
                noSimi = _ReSetPassword.text;
            }else{
                [MBProgressHUD showError:@"密码格式不正确或两次输入密码不同"];
                return;
            }
        }
        if (_simiReSetTF.text.length>0) {
            if ([[DataManagerTool sharedDataManagetTool]judgemetPasswordIsRight:_simiReSetTF.text] && [_simiReSet2.text isEqualToString:_simiReSetTF.text]) {
                simi = _simiReSetTF.text;
            }else{
                [MBProgressHUD showError:@"密码格式不正确或两次输入密码不同"];
                return;
            }
        }
        dic = @{@"password":noSimi, @"simiPassword":simi};
        [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"myPassword"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    if (_ReSetPassword.text.length == 0) {
        [[DataManagerTool sharedDataManagetTool]setSimi:1];
    }else{
        [[DataManagerTool sharedDataManagetTool]setSimi:0];
    }
    GroupingViewController *gc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"groupingC"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:gc];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = navi;
    [MBProgressHUD showSuccess:@"修改成功"];
}

-(void)canLogin{
    BOOL right;
    if (_type == 1) {
        right = [[DataManagerTool sharedDataManagetTool] judgemetAlbumPasswordIsRight:_ReSetPassword.text];
    }else{
        right = [[DataManagerTool sharedDataManagetTool] judgemetPasswordIsRight:_ReSetPassword.text];
    }
    
    if (right && [_ReSetPassword.text isEqualToString:_ReSetPassword2.text]) {
        _okButton.enabled = YES;
    }else{
        _okButton.enabled = NO;
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
