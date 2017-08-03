//
//  SelectAlbumTableViewController.m
//  SPAlbum
//
//  Created by Mac on 2017/6/15.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "SelectAlbumTableViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SelectCell.h"
#import "SelectPhotoCollectionViewController.h"
#import "DataManagerTool.h"
@interface SelectAlbumTableViewController ()
@property (nonatomic, strong) ALAssetsLibrary *lib;
@property (nonatomic, strong) NSMutableArray *Ma;
@end

@implementation SelectAlbumTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择相册";
    self.tableView.tableFooterView = [UIView new];
    _Ma = [NSMutableArray array];
    [self getDataSourse];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
}
-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)getDataSourse{
    if (!_lib) {
        _lib = [[ALAssetsLibrary alloc] init];
    }
    [_lib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        if (group) {
            [_Ma addObject:group];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _Ma.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selectCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    ALAssetsGroup *group = _Ma[indexPath.row];
    NSString *title = [group valueForProperty:ALAssetsGroupPropertyName];
    CGImageRef image = [group posterImage];
    cell.imageV.image = [UIImage imageWithCGImage:image];
    cell.titleLabel.text = title;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ALAssetsGroup *group = _Ma[indexPath.row];
    [group setAssetsFilter:[ALAssetsFilter allAssets]];
    NSMutableArray *a = [NSMutableArray array];
    [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [a addObject:result];
        }
        
    }];
    [[DataManagerTool sharedDataManagetTool] setPhotos:[a copy]];
    SelectPhotoCollectionViewController *sc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"selectPhotosCC"];
    [self.navigationController pushViewController:sc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
