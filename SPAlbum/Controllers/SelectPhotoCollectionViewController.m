//
//  SelectPhotoCollectionViewController.m
//  SPAlbum
//
//  Created by Mac on 2017/6/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "SelectPhotoCollectionViewController.h"
#import "SelectPhotoCell.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DataManagerTool.h"
#import "UIColor+FlatUI.h"
#import "MBProgressHUD+KR.h"
@interface SelectPhotoCollectionViewController ()
@property (nonatomic, strong) NSArray *photoA;
//@property (nonatomic, strong) NSMutableArray *selectPA;
@property (nonatomic, strong) NSMutableDictionary *dic;
@end

@implementation SelectPhotoCollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择照片";
    //_selectPA = [NSMutableArray array];
    _dic = [NSMutableDictionary dictionary];
    _photoA = [[DataManagerTool sharedDataManagetTool]getPhotos];
    [self.collectionView reloadData];
    UIButton *bu = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    bu.layer.cornerRadius = 4;
    bu.layer.borderColor = [UIColor whiteColor].CGColor;
    bu.layer.borderWidth = 1;
    bu.titleLabel.font = [UIFont systemFontOfSize:14];
    
    [bu setTitle:@"确定" forState:UIControlStateNormal];
    [bu addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:bu];

    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
}
-(void)select:(UIBarButtonItem *)sender{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"selectPhoto" object:_dic];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    NSLog(@"");
}



#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photoA.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"selectPhotoCell" forIndexPath:indexPath];
    ALAsset *set = _photoA[indexPath.row];
    //ALAssetRepresentation *tation = [set defaultRepresentation];
    CGImageRef image = [set thumbnail];
    cell.imageV.image = [UIImage imageWithCGImage:image];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectPhotoCell *cell = (SelectPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    ALAsset *set = _photoA[indexPath.row];
    ALAssetRepresentation *rt = [set defaultRepresentation];
    NSString *title = [[set valueForProperty:ALAssetPropertyAssetURL]absoluteString];
    NSRange range = [title rangeOfString:@"?id="];
    title = [title substringFromIndex:range.location+range.length];
    UIImage *image = _dic[title];
    if (!image) {
        if (_dic.allKeys.count>8) {
            [MBProgressHUD show:@"最多只可以选择9张照片" icon:nil view:nil];
            return;
        }
        CGImageRef cimage = [rt fullResolutionImage];
        image = [UIImage imageWithCGImage:cimage scale:rt.scale orientation:(UIImageOrientation)rt.orientation];
        NSData *imageD = UIImageJPEGRepresentation(image, 1.0);
        image = [UIImage imageWithData:imageD];
        [_dic setValue:image forKey:title];
    }else{
        [_dic removeObjectForKey:title];
    }
    cell.selectButton.hidden = !cell.selectButton.hidden;
//    if (cell.selectButton.hidden == YES) {
//        
//        [_selectPA removeObject:image];
//    }else{
//        [_selectPA addObject:image];
//    }
    if (_dic.allKeys.count>0) {
        self.navigationItem.rightBarButtonItem.customView.hidden = NO;
        self.title = [NSString stringWithFormat:@"已选择 %lu 张",(unsigned long)_dic.allKeys.count];
    }else{
        self.navigationItem.rightBarButtonItem.customView.hidden = YES;
        self.title = @"选择照片";
    }
}
#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
