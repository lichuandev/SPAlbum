//
//  SelectAlbumGroupViewController.m
//  SPAlbum
//
//  Created by Mac on 2017/6/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "SelectAlbumGroupViewController.h"
#import "DBManagerTool.h"
#import "PhotoKind.h"
#import "DataManagerTool.h"
#import "UIColor+FlatUI.h"
@interface SelectAlbumGroupViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tab;
@property (nonatomic, strong) NSArray *groups;
@property (nonatomic, assign) int isSimi;
@end

@implementation SelectAlbumGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tab.delegate = self;
    self.tab.dataSource = self;
    self.tab.tableFooterView = [UIView new];
    self.tab.separatorStyle = UITableViewCellSeparatorStyleNone;
    _isSimi = [[DataManagerTool sharedDataManagetTool]getIsSimi];
    _groups = [DBManagerTool getAllPhotoKinds:_isSimi];
    self.preferredContentSize = CGSizeMake(100, _groups.count*35+47);
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _groups.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    }
    PhotoKind *kind = _groups[indexPath.row];
    UILabel *label = [cell.contentView viewWithTag:111];
    if (!label) {
        label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 35)];
        label.textColor = [UIColor colorFromHexCode:@"ff2d39"];
        label.font = [UIFont systemFontOfSize:14];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = kind.name;
        label.tag = 111;
        [cell.contentView addSubview:label];
    }else{
        label.text = kind.name;
    }
    UIView *view = [cell.contentView viewWithTag:222];
    if (!view) {
        view = [[UIView alloc] initWithFrame:CGRectMake(0, 34, 100, 1)];
        view.tag = 222;
        view.backgroundColor = [UIColor colorFromHexCode:@"e6e6e6"];
        [cell.contentView addSubview:view];
    }
   // cell.textLabel.text = kind.name;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PhotoKind *kind = _groups[indexPath.row];
    if (_select) {
        _select(kind.name);
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    NSLog(@"");
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
