//
//  PhotosViewController.m
//  SPAlbum
//
//  Created by Mac on 2017/6/2.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "PhotosViewController.h"
#import "DBManagerTool.h"
#import "DataManagerTool.h"
#import "Photo.h"
#import "PublicView.h"
#import "MBProgressHUD+KR.h"
#import "SKFCamera.h"
#import "HandlePicViewController.h"
#import "PhotoCell.h"
#import "PhotosCell.h"
#import "SelectAlbumTableViewController.h"
#import "UIColor+FlatUI.h"
#import "SelectAlbumGroupViewController.h"
@interface PhotosViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIPopoverPresentationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITableView *photosTab;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *outB;
@property (weak, nonatomic) IBOutlet UIButton *removeB;
@property (weak, nonatomic) IBOutlet UIButton *deletB;
@property (weak, nonatomic) IBOutlet UIButton *selectB;
@property (weak, nonatomic) IBOutlet UIButton *inB;
@property (nonatomic, strong) SelectAlbumGroupViewController *selecC;
@property (nonatomic, strong) NSMutableArray *photosA;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, assign) int isSimi;
@property (nonatomic, assign) BOOL tab;
@property (nonatomic, strong) NSMutableArray *selectA;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _kind.name;
    _isSimi = [[DataManagerTool sharedDataManagetTool]getIsSimi];
    _photosA = [NSMutableArray array];
    _selectA = [NSMutableArray array];
    _isEditing = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"切换" style:UIBarButtonItemStylePlain target:self action:@selector(selectView:)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPhotos:) name:@"selectPhoto" object:nil];
}
-(void)selectView:(UIBarButtonItem *)sender{
    if (_isEditing) {
        [self editing];
    }
    _tab = !_tab;
    [[NSUserDefaults standardUserDefaults]setBool:_tab forKey:@"isTab"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self refreshView];
    
}
-(void)refreshView{
    if (_photosA.count>0) {
        if (_tab) {
            _photosTab.hidden = NO;
            _collectionView.hidden = YES;
            _photosTab.delegate = self;
            _photosTab.dataSource = self;
            _photosTab.bounces = NO;
            _photosTab.tableFooterView = [UIView new];
            [_selectB setTitle:@"编辑" forState:UIControlStateNormal];
            [_selectB setImage:[UIImage imageNamed:@"编辑"] forState:UIControlStateNormal];
            _outB.hidden = YES;
            _removeB.hidden = YES;
            _deletB.hidden = YES;
            _photosTab.allowsSelectionDuringEditing = YES;
            [_photosTab reloadData];
        }else{
            _photosTab.hidden = YES;
            _collectionView.hidden = NO;
            _collectionView.hidden = NO;
            _photosTab.hidden = YES;
            _collectionView.delegate = self;
            _collectionView.dataSource = self;
            [_selectB setTitle:@"选择" forState:UIControlStateNormal];
            [_selectB setImage:[UIImage imageNamed:@"选择"] forState:UIControlStateNormal];
            [self.collectionView reloadData];
        }
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _tab = [[NSUserDefaults standardUserDefaults]boolForKey:@"isTab"];
    // 获取相册相片
    [self getPhotos];
    [self refreshView];
    
    
}
-(void)getPhotos:(NSNotification *)sender{
    NSDictionary *dic = (NSDictionary *)sender.object;
    //[MBProgressHUD showMessage:@"请稍后！"];
    for (NSString *title in dic.allKeys) {
        UIImage *image = dic[title];
        [self handleImage:image title:title];
    }
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:@"添加完成"];
}
-(void)getPhotos{
    _photosA = [[DBManagerTool getAllPhotos:_kind.name type:_isSimi] mutableCopy];
    [self.photosTab reloadData];
    [self.collectionView reloadData];
    if (_photosA.count == 0) {
        _photosTab.hidden = YES;
        _collectionView.hidden = YES;
        _toolView.hidden = YES;
    }
}
-(void)editing{
    _isEditing = !_isEditing;
    _inB.enabled = !_inB.enabled;
    if (_inB.enabled) {
        [_inB setTitleColor:[UIColor colorFromHexCode:@"ff2d39"] forState:UIControlStateNormal];
    }else{
        [_inB setTitleColor:[UIColor colorFromHexCode:@"999999"] forState:UIControlStateNormal];
    }
    NSString *t;
    if (_tab) {
        [self.photosTab setEditing:!self.photosTab.editing animated:YES];
        t = self.photosTab.isEditing ? @"完成" : @"编辑";
    }else{
        t = _isEditing ? @"取消" : @"选择";
    }
    
    //    isEditing editing的getter方法的 新名字
   
    [_selectB setTitle:t forState:UIControlStateNormal];
    _selectB.selected = !_selectB.selected;
    
}
- (IBAction)addPhoto:(id)sender {
    [self addPhotos];
}
- (IBAction)add:(id)sender {
    [self addPhotos];
}
- (IBAction)putOut:(id)sender {
    [MBProgressHUD showMessage:@"请稍后"];
    NSArray *temA = [_selectA copy];
    for (Photo *pho in temA) {
        UIImage *image = [UIImage imageWithData:pho.content];
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
        [_selectA removeObject:pho];
    }
    [self editing];
    [self setCollectV];
    [self.collectionView reloadData];
    [MBProgressHUD hideHUD];
    [MBProgressHUD showSuccess:@"导出成功"];
}
- (IBAction)delet:(id)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"删除后该照片将无法恢复，是否继续删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *temA = [_selectA copy];
        for (Photo *pho in temA) {
            [self deletePhoto:pho];
        }
        [_collectionView reloadData];
        [self editing];
        [self setCollectV];
        if (_photosA.count<1) {
            _collectionView.hidden = YES;
            _toolView.hidden = YES;
        }
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:yes];
    [alertC addAction:no];
    [self presentViewController:alertC animated:YES completion:nil];
    
}
- (IBAction)remove:(id)sender {
    [self move];
}
-(void)move{
    _selecC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"selectC"];
    _selecC.modalPresentationStyle = UIModalPresentationPopover;
    _selecC.popoverPresentationController.sourceView = _removeB;
    _selecC.popoverPresentationController.sourceRect = _removeB.bounds;
    _selecC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    _selecC.popoverPresentationController.delegate = self;
    __weak typeof(self)weakSelf = self;
    _selecC.select = ^(NSString *kind){
        NSArray *temA = [weakSelf.selectA copy];
        for (Photo *photo in temA) {
            if ([kind isEqualToString:photo.photoKind]) {
                [MBProgressHUD show:@"已在该分组" icon:nil view:weakSelf.view];
                return ;
            }
            if ([DBManagerTool editPhotoGroup:kind oldName:photo.photoID type:weakSelf.isSimi]) {
                [weakSelf.selectA removeObject:photo];
                [weakSelf.photosA removeObject:photo];
            }
        }
        
        [weakSelf.collectionView reloadData];
        [MBProgressHUD showSuccess:@"移动成功"];
        [weakSelf editing];
        [weakSelf setCollectV];
        if (weakSelf.photosA.count<1) {
            weakSelf.collectionView.hidden = YES;
            weakSelf.toolView.hidden = YES;
        }
    };
    [self presentViewController:_selecC animated:YES completion:nil];
}

- (IBAction)select:(id)sender {
    [self editing];
    
    if (!_tab) {
        if (_selectA.count>0) {
            [_selectA removeAllObjects];
        }
        [self setCollectV];
        [_collectionView reloadData];
        
    }
    
}
-(void)deletePhoto:(Photo *)pho{
    if ([DBManagerTool deletePhoto:pho type:_isSimi]) {
        //[MBProgressHUD showSuccess:@"删除成功"];
        [_photosA removeObject:pho];
        [_selectA removeObject:pho];
    }
}

-(void)addPhotos{
    
    UIAlertController *alerViewC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *album = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SelectAlbumTableViewController *tc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"selectTc"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:tc];
        [self presentViewController:nav animated:YES completion:nil];

    }];
    UIAlertAction *cama = [UIAlertAction actionWithTitle:@"相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        SKFCamera *ca = [[SKFCamera alloc]init];
        __weak typeof(self)weakSelf = self;
        ca.fininshcapture = ^(UIImage *image) {
            [weakSelf handleImage:image title:nil];
        };
        [self presentViewController:ca animated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }];
    [alerViewC addAction:album];
    [alerViewC addAction:cama];
    [alerViewC addAction:cancel];
    [self presentViewController:alerViewC animated:YES completion:nil];
    
}
-(void)handleImage:(UIImage *)image title:(NSString *)title{
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    UIImage *editedImage = [self compactImage:image size:CGSizeMake(200, 200)];
    NSData *editedImageData = UIImagePNGRepresentation(editedImage);
    [self addData:imageData smallImage:editedImageData title:title];
}
-(void)addData:(NSData *)imageData smallImage:(NSData *)editedImageData title:(NSString *)title{
    Photo *photo = [Photo new];
    NSString *dateS = [[DataManagerTool sharedDataManagetTool] getDateS:[NSDate date]];
    photo.name = dateS;
    photo.content = imageData;
    photo.smallContent = editedImageData;
    photo.photoKind = _kind.name;
    photo.size = [NSString stringWithFormat:@"%.0luKB",imageData.length/1024];
    if (title.length>0) {
        photo.photoID = [NSString stringWithFormat:@"%@_%@",title,dateS];
    }else{
        photo.photoID = dateS;
    }
    [_photosA addObject:photo];
    if (_photosTab.hidden == YES) {
        _photosTab.hidden = NO;
        _toolView.hidden = NO;
    }
    [DBManagerTool insertPhoto:photo type:_isSimi];
    if (_tab) {
        [self.photosTab reloadData];
    }else{
        [self.collectionView reloadData];
    }
    
}
-(UIImage *)compactImage:(UIImage *)image size:(CGSize)size{
    CGSize imageSize = image.size;
    if (imageSize.width<=size.width&&imageSize.height<=size.height) {
        return image;
    }
    if (imageSize.width == 0 || imageSize.height == 0) {
        return image;
    }
    CGFloat widthRatio = size.width/imageSize.width;
    CGFloat heightRatio = size.height/imageSize.height;
    CGFloat scale = widthRatio<heightRatio?widthRatio:heightRatio;
    CGSize newSize = CGSizeMake(imageSize.width*scale, imageSize.height*scale);
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}
-(void)setCollectV{
    if (_selectA.count>0) {
        _outB.hidden = NO;
        _removeB.hidden = NO;
        _deletB.hidden = NO;
    }else{
        _outB.hidden = YES;
        _removeB.hidden = YES;
        _deletB.hidden = YES;
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"删除后该照片将无法恢复，是否继续删除？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *yes = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            Photo *pho = _photosA[indexPath.row];
            [DBManagerTool deletePhoto:pho type:_isSimi];
            [_photosA removeObjectAtIndex:indexPath.row];
            [_photosTab deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            if (_photosA.count == 0) {
                _photosTab.hidden = YES;
                _collectionView.hidden = YES;
                _toolView.hidden = YES;
            }
        }];
        UIAlertAction *no = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:yes];
        [alertC addAction:no];
        [self presentViewController:alertC animated:YES completion:nil];
        
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _photosA.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell" forIndexPath:indexPath];
    cell.selectionStyle = _isEditing ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleBlue;
    Photo *photo = _photosA[indexPath.row];
    cell.imageV.image = [[UIImage alloc]initWithData:photo.smallContent];
    cell.titleLabel.text = photo.name;
    cell.detailL.text = photo.size;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Photo *photo = _photosA[indexPath.row];
    if (_isEditing) {
        [self editPhotoName:photo indexPath:indexPath];
    }else{
        HandlePicViewController *hc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"handlePicC"];
            hc.photo = photo;
        hc.phoA = _photosA.copy;
            [self.navigationController pushViewController:hc animated:YES];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Photo *photo = _photosA[indexPath.row];
    if (_isEditing) {
        PhotosCell *cell = (PhotosCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if ([_selectA containsObject:photo]) {
            [_selectA removeObject:photo];
            [cell.bu setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
        }else{
            [_selectA addObject:photo];
            [cell.bu setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        }
        [self setCollectV];
        
    }else{
        HandlePicViewController *hc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"handlePicC"];
        hc.photo = photo;
        hc.phoA = _photosA.copy;
        
        [self.navigationController pushViewController:hc animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _photosA.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photosCell" forIndexPath:indexPath];
    cell.bu.hidden = !_isEditing;
    [cell.bu setImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
    Photo *pho = _photosA[indexPath.row];
    cell.imageV.image = [UIImage imageWithData:pho.smallContent];
    return cell;
}
-(void)editPhotoName:(Photo *)photo indexPath:(NSIndexPath *)indexPath{
    __weak typeof(self)weakSelf = self;
    PublicView *pv = [[NSBundle mainBundle]loadNibNamed:@"PublicView" owner:nil options:nil].firstObject;
    __weak typeof(pv)weakPV = pv;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [pv.password2 becomeFirstResponder];
    pv.password2.keyboardType = UIKeyboardTypeDefault;
    pv.frame = window.bounds;
    pv.setView.hidden = YES;
    pv.inputView.hidden = NO;
    pv.titleLabel.text = @"输入相片名字";
    pv.fogetB.hidden = YES;
    [window addSubview:pv];
    pv.buttonClickBlock = ^(int index, NSString *name, NSString *password){
        NSLog(@"index:%d",index);
        switch (index) {
            case 2:{
                NSArray *tempA = [_photosA copy];
                for (Photo *photo in tempA) {
                    if ([photo.name isEqualToString:password]) {
                        [MBProgressHUD showError:@"该相片名已存在，请重新命名"];
                        return ;
                    }
                }
               
                [DBManagerTool editPhotoName:password oldName:photo.photoID type:_isSimi];
                photo.name = password;
                [weakSelf.photosTab reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
                [weakPV removeFromSuperview];
            }
                break;
                
            default:
                [weakPV removeFromSuperview];
                break;
        }
    };
    
}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}




@end
