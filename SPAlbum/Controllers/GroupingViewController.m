//
//  GroupingViewController.m
//  SPAlbum
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "GroupingViewController.h"
#import "DBManagerTool.h"
//#import "TableViewFooterView.h"
#import "PublicView.h"
#import "MBProgressHUD+KR.h"
#import "PhotosViewController.h"
#import "PasswordProtectViewController.h"
#import "DataManagerTool.h"
#import "AlbumCell.h"
@interface GroupingViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITableView *photoKindsTab;
@property (nonatomic, strong) NSMutableArray *photoKindsA;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) int isSimi;
@end

@implementation GroupingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的分组";
    _isSimi = [[DataManagerTool sharedDataManagetTool]getIsSimi];
    _photoKindsA = [NSMutableArray array];
    _isEditing = NO;
    _photoKindsTab.delegate = self;
    _photoKindsTab.dataSource = self;
    _photoKindsTab.bounces = NO;
    _photoKindsTab.allowsSelectionDuringEditing = YES;
    _photoKindsTab.tableFooterView = [UIView new];
    
    //_photoKindsTab.clipsToBounds
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editing:)];
    // 获取相册集合
    _photoKindsA = [[DBManagerTool getAllPhotoKinds:_isSimi] mutableCopy];
    
    if (_photoKindsA.count == 0) {
        _photoKindsTab.hidden = YES;
        _addButton.hidden = YES;
    }
}
-(void)editing:(UIBarButtonItem*)sender {
    [self.photoKindsTab setEditing:!self.photoKindsTab.editing animated:YES];
    //    isEditing editing的getter方法的 新名字
    sender.title = self.photoKindsTab.isEditing ? @"完成" : @"编辑";
    _isEditing = !_isEditing;
}
- (IBAction)addPhotoKinds:(id)sender {
    [self addKind];
}
-(void)addKind{
    __weak typeof(self)weakSelf = self;
    PublicView *pv = [[NSBundle mainBundle]loadNibNamed:@"PublicView" owner:nil options:nil].firstObject;
    __weak typeof(pv)weakPV = pv;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    pv.frame = window.bounds;
//    pv.setView.layer.cornerRadius = 8;
//    pv.setView.clipsToBounds = YES;
    [pv.kindNameTF becomeFirstResponder];
    [window addSubview:pv];
    pv.buttonClickBlock = ^(int index, NSString *name, NSString *password){
        switch (index) {
            case 1:{
                if (_photoKindsTab.hidden == YES) {
                    _photoKindsTab.hidden = NO;
                    _addButton.hidden = NO;
                }
                NSArray *tempA = [_photoKindsA copy];
                for (PhotoKind *kind in tempA) {
                    if ([kind.name isEqualToString:name]) {
                       [MBProgressHUD showError:@"该分组已存在，请请重新命名"];
                        return ;
                    }
                }
                PhotoKind *kind = [PhotoKind new];
                kind.name = name;
                kind.password = password;
                [DBManagerTool insertPhotoKind:kind type:_isSimi];
                
                [weakSelf.photoKindsA addObject:kind];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.photoKindsA.count-1 inSection:0];
                [weakSelf.photoKindsTab insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                [weakPV removeFromSuperview];
            }
                break;
                
            default:
                [weakPV removeFromSuperview];
                break;
        }
    };
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"删除后该分组内的所有照片将无法恢复，是否继续删除？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            PhotoKind *kind = _photoKindsA[indexPath.row];
            [DBManagerTool deletePhotoKind:kind type:_isSimi];
            [DBManagerTool deletePhotoUseKindName:kind.name type:_isSimi];
            
            [_photoKindsA removeObjectAtIndex:indexPath.row];
            [_photoKindsTab deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            if (_photoKindsA.count == 0) {
                _photoKindsTab.hidden = YES;
                _addButton.hidden = YES;
            }
        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:yes];
        [alertC addAction:no];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _photoKindsA.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlbumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"albumCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = _isEditing ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
    PhotoKind *kind = _photoKindsA[indexPath.row];
    if (kind.password.length>0) {
        cell.imagev.image = [UIImage imageNamed:@"锁"];
    }else{
        cell.imagev.image = [UIImage imageNamed:@"牛"];
    }
    
    cell.titleLabel.text = kind.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoKind *kind = _photoKindsA[indexPath.row];
    if (_isEditing) {
        [self editKindName:kind indexPath:indexPath];
    }else{
        if (kind.password.length>0) {
            [self usePassword:kind];
        }else{
            PhotosViewController *pc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"photosC"];
            pc.kind = kind;
            [self.navigationController pushViewController:pc animated:YES];
        }
    }
}
-(void)usePassword:(PhotoKind *)kind{
    PublicView *pv = [[NSBundle mainBundle]loadNibNamed:@"PublicView" owner:nil options:nil].firstObject;
    __weak typeof(self)weakSelf = self;
    __weak typeof(pv)weakPV = pv;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    pv.frame = window.bounds;
    pv.setView.hidden = YES;
    pv.inputView.hidden = NO;
    [window addSubview:pv];
    pv.buttonClickBlock = ^(int index, NSString *name, NSString *password){
        switch (index) {
            case 1:{
                PasswordProtectViewController *ppc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"passwordProtectC"];
                ppc.type = 1;
                ppc.kind = kind;
                [self.navigationController pushViewController:ppc animated:YES];
                [weakPV removeFromSuperview];
            }
                break;
            case 2:{
                if ([password isEqualToString:kind.password]) {
                    PhotosViewController *pc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"photosC"];
                    pc.kind = kind;
                    [weakSelf.navigationController pushViewController:pc animated:YES];
                    [weakPV removeFromSuperview];
                }else{
                    [MBProgressHUD showError:@"密码错误"];
                }
            }
                break;
            default:
                [weakPV removeFromSuperview];
                break;
        }
    };

}
-(void)editKindName:(PhotoKind *)kind indexPath:(NSIndexPath *)indexPath{
    __weak typeof(self)weakSelf = self;
    PublicView *pv = [[NSBundle mainBundle]loadNibNamed:@"PublicView" owner:nil options:nil].firstObject;
    __weak typeof(pv)weakPV = pv;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [pv.kindNameTF becomeFirstResponder];
    pv.frame = window.bounds;
    [window addSubview:pv];
    pv.buttonClickBlock = ^(int index, NSString *name, NSString *password){
        switch (index) {
            case 1:{
                NSArray *tempA = [_photoKindsA copy];
                for (PhotoKind *kind in tempA) {
                    if ([kind.name isEqualToString:name]) {
                        [MBProgressHUD showError:@"该分组已存在，请请重新命名"];
                        return ;
                    }
                }
                if (password.length>0) {
                    [DBManagerTool editPhotoKindPassword:password oldName:kind.password type:_isSimi];
                    kind.password = password;
                }
                [DBManagerTool editPhotoKindName:name oldName:kind.name type:_isSimi];
                kind.name = name;
                [weakSelf.photoKindsTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                [weakPV removeFromSuperview];
            }
                break;
                
            default:
                [weakPV removeFromSuperview];
                break;
        }
    };
  
}
- (IBAction)add:(id)sender {
    [self addKind];
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
