//
//  SetPasswordViewController.m
//  SPAlbum
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "SetPasswordViewController.h"
#import "DataManagerTool.h"
#import "UIView+Extension.h"
#import "LoginViewController.h"
#import "UIColor+FlatUI.h"
#import "MBProgressHUD+KR.h"
@interface SetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *questionTF;
@property (weak, nonatomic) IBOutlet UITextField *answerTF;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageV;
@property (weak, nonatomic) IBOutlet UITextField *rePassword;
@property (weak, nonatomic) IBOutlet UIImageView *passwordImageV2;
@property (weak, nonatomic) IBOutlet UIButton *loginB;
@property (weak, nonatomic) IBOutlet UITextField *siPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *siRePT;
@property (weak, nonatomic) IBOutlet UIImageView *simiImage;
@property (weak, nonatomic) IBOutlet UIImageView *simiImage2;

@end

@implementation SetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置密码";
}
- (IBAction)simi:(id)sender {
    _simiImage.hidden =_siPasswordTF.text.length>0? NO: YES;
    BOOL result = [[DataManagerTool sharedDataManagetTool] judgemetPasswordIsRight:_siPasswordTF.text];
    if (result) {
        _simiImage.image = [UIImage imageNamed:@"answer_right"];
    }else{
        _simiImage.image = [UIImage imageNamed:@"answer_error"];
    }
}
- (IBAction)simiRe:(id)sender {
    _simiImage2.hidden =_siRePT.text.length>0? NO: YES;
    if ([_siRePT.text isEqualToString:_siPasswordTF.text]) {
        _simiImage2.image = [UIImage imageNamed:@"answer_right"];
    }else{
        _simiImage2.image = [UIImage imageNamed:@"answer_error"];
    }
}
- (IBAction)inputPassword:(UITextField *)sender {
    _passwordImageV.hidden =_passwordTF.text.length>0? NO: YES;
    BOOL result = [[DataManagerTool sharedDataManagetTool] judgemetPasswordIsRight:_passwordTF.text];
    if (result) {
        _passwordImageV.image = [UIImage imageNamed:@"answer_right"];
    }else{
        _passwordImageV.image = [UIImage imageNamed:@"answer_error"];
    }
    [self canLogin];
}
- (IBAction)reinputPassword:(UITextField *)sender {
    _passwordImageV2.hidden =_rePassword.text.length>0? NO: YES;
    if ([_rePassword.text isEqualToString:_passwordTF.text]) {
        _passwordImageV2.image = [UIImage imageNamed:@"answer_right"];
    }else{
        _passwordImageV2.image = [UIImage imageNamed:@"answer_error"];
    }
    [self canLogin];
}
- (IBAction)questionEditing:(UITextField *)sender {
    [self canLogin];
}
- (IBAction)question:(UITextField *)sender {
    self.view.y -= 1;
    [UIView animateWithDuration:0.2 animations:^{
        self.view.y = -150;
    }];
}
- (IBAction)answerEditing:(UITextField *)sender {
    [self canLogin];
}

- (IBAction)answer:(UITextField *)sender {
    [UIView animateWithDuration:0.2 animations:^{
        self.view.y = -150;
    }];
}

- (IBAction)login:(id)sender {
    if ([_passwordTF.text isEqualToString:_siPasswordTF.text]) {
        [MBProgressHUD showError:@"普通密码和私密密码不能形同"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isTheFirstTimeLogin"];
    NSDictionary *paDic = @{@"password":_passwordTF.text,@"simiPassword":_siPasswordTF.text};
    [[NSUserDefaults standardUserDefaults] setObject:paDic forKey:@"myPassword"];
    NSDictionary *pp = @{@"question":_questionTF.text,@"answer":_answerTF.text};
    [[NSUserDefaults standardUserDefaults] setObject:pp forKey:@"passwordProtect"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     LoginViewController*lc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"loginC"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lc];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = navi;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)canLogin{
    BOOL right = [[DataManagerTool sharedDataManagetTool] judgemetPasswordIsRight:_passwordTF.text];
    if (right && [_rePassword.text isEqualToString:_passwordTF.text] && _questionTF.text.length > 0 && _answerTF.text.length > 0) {
        _loginB.enabled = YES;
        [_loginB setBackgroundColor:[UIColor colorFromHexCode:@"ff2d39"]];
    }else{
        _loginB.enabled = NO;
        [_loginB setBackgroundColor:[UIColor colorFromHexCode:@"b6b6b6"]];
    }
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    self.view.y += 1;
    [UIView animateWithDuration:0.2 animations:^{
        self.view.y = 64;
    }];
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
