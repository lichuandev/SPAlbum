//
//  PasswordProtectViewController.m
//  SPAlbum
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "PasswordProtectViewController.h"
#import "ReSetPasswordViewController.h"
#import "MBProgressHUD+KR.h"
@interface PasswordProtectViewController ()

@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerTF;
@property (nonatomic, strong) NSDictionary *dic;
@end

@implementation PasswordProtectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"找回密码";
    _dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwordProtect"];
    NSLog(@"dic:%@",_dic);
    _questionLabel.text = _dic[@"question"];
}
- (IBAction)okButton:(id)sender {
    if (_answerTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入答案"];
        return;
    }
    if ([_answerTF.text isEqualToString:_dic[@"answer"]]) {
        ReSetPasswordViewController *rspc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"reSetPasswordC"];
        rspc.type = _type;
        rspc.kind = _kind;
        [self.navigationController pushViewController:rspc animated:YES];
    }else{
        [MBProgressHUD showError:@"答案错误"];
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
