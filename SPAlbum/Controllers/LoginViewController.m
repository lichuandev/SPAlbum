//
//  LoginViewController.m
//  SPAlbum
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "LoginViewController.h"
#import "GroupingViewController.h"
#import "DataManagerTool.h"
#import "MBProgressHUD+KR.h"
#import "PasswordProtectViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (nonatomic, assign) int times;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *fogetButton;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"登陆相册";
    _times = 0;
    //判断相册有没有被锁，以及被锁的时间
    [self canUseAlbum];
}
-(void)canUseAlbum{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"albumLock"];
    if (dic && [dic[@"lock"] boolValue] == true) {
        NSTimeInterval timeInterval = [[DataManagerTool sharedDataManagetTool] getTimeIntervals:dic[@"dates"]];
        NSLog(@"timeInterval:%lf",timeInterval);
        if (timeInterval/3600 >= 2) {
            BOOL lock = NO;
            NSDictionary *dic = @{@"lock":@(lock),@"dates":@""};
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"albumLock"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else{
            [self lockTheView];
        }
        
    }else{
        NSLog(@"没有被锁");
    }
}
- (IBAction)login:(id)sender {
    if (_passwordTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入密码"];
        return;
    }
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"myPassword"];
    if ([dic[@"password"] isEqualToString:_passwordTF.text]) {
        [[DataManagerTool sharedDataManagetTool]setSimi:0];
        [self gotoLogin];
    }else if ([dic[@"simiPassword"] isEqualToString:_passwordTF.text]) {
        [[DataManagerTool sharedDataManagetTool]setSimi:1];
        [self gotoLogin];
    }else{
        [MBProgressHUD showError:@"密码错误"];
        _times ++;
        if (_times >= 3) {
            [self lockTheView];
            NSString *dates = [[DataManagerTool sharedDataManagetTool] getDateS:[NSDate date]];
            BOOL lock = YES;
            NSDictionary *dic = @{@"lock":@(lock),@"dates":dates};
            [[NSUserDefaults standardUserDefaults] setObject:dic forKey:@"albumLock"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    }
    
}
-(void)gotoLogin{
    GroupingViewController *gc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"groupingC"];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:gc];
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = navi;
}
-(void)lockTheView
{
    _promptLabel.text = @"密码连续输错三次，相册被锁 2 小时！";
    _passwordTF.userInteractionEnabled = NO;
    _loginButton.enabled = NO;
    _fogetButton.enabled = NO;
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
