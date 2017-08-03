//
//  HandlePicViewController.m
//  SPAlbum
//
//  Created by Mac on 2017/6/5.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "HandlePicViewController.h"
#import "MBProgressHUD+KR.h"
#import "DBManagerTool.h"
#import "SelectAlbumGroupViewController.h"
#import "TOCropViewController.h"
#import "UIView+Extension.h"
#import "DataManagerTool.h"
#define BUTTONWIDTH 40
#define SPASE 25
#define CONTRAINT (self.view.width-4*BUTTONWIDTH-SPASE*2)/3
@interface HandlePicViewController ()<UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate,TOCropViewControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *C1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *C2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *C3;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageV;
@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIButton *moveB;
@property (nonatomic, assign) int isSimi;
@property (nonatomic, strong) SelectAlbumGroupViewController *selecC;
@property (nonatomic, assign) CGRect Oframe;
@end

@implementation HandlePicViewController

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if (self.picImageV.hidden == YES) {
        self.picImageV.hidden = NO;
    }
}
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    _C1.constant = CONTRAINT;
    _C2.constant = CONTRAINT;
    _C3.constant = CONTRAINT;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isSimi = [[DataManagerTool sharedDataManagetTool]getIsSimi];
    [self setImageV];
    self.picImageV.userInteractionEnabled = YES;
    [self addGesture];
    NSInteger index = [_phoA indexOfObject:_photo];
    [self resetView:index];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"分享"] style:UIBarButtonItemStyleDone target:self action:@selector(share:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}
-(void)addGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.picImageV addGestureRecognizer:tap];
    UIPinchGestureRecognizer *pin = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pin:)];
    pin.delegate = self;
    [self.view addGestureRecognizer:pin];
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    pan.delegate = self;
    pan.minimumNumberOfTouches = 1;
    [self.view addGestureRecognizer:pan];
}
-(void)setImageV{
    UIImage *image = [UIImage imageWithData:_photo.content];
    self.picImageV.image = image;
    CGFloat s = self.view.width/image.size.width;
    self.picImageV.size = CGSizeMake(self.view.width,s*image.size.height);
    if (self.picImageV.height>self.view.height+5) {
        s = self.view.height/image.size.height;
        self.picImageV.size = CGSizeMake(_picImageV.width*s,self.view.height);
    }
    self.picImageV.center = self.view.center;
    _Oframe = _picImageV.frame;
}
-(void)share:(UIBarButtonItem *)sender{
    
}
-(void)tap{
    self.navigationController.navigationBar.hidden = !self.navigationController.navigationBar.hidden;
    self.toolView.hidden = !self.toolView.hidden;
    if (self.toolView.hidden) {
        self.view.backgroundColor = [UIColor blackColor];
    }else{
        self.view.backgroundColor = [UIColor whiteColor];
    }
}
-(void)pan:(UIPanGestureRecognizer *)sender{
    if (self.view.width >= _picImageV.frame.size.width){
        return;
    }
    
    
    CGPoint point = [sender translationInView:sender.view];
    CGPoint center = _picImageV.center;
    center.x += point.x;
    center.y += point.y;
    _picImageV.center = center;
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self moveToCenter];
        [self moveFrame];
    }
    [sender setTranslation:CGPointZero inView:self.view];
    
}
-(void)moveFrame{
    if (self.view.width < _picImageV.width) {
        if (_picImageV.frame.origin.x>0) {
            _picImageV.x -= 0.1;
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _picImageV.x = 0;
            } completion:^(BOOL finished) {
                
            }];
        }
        
        if (_picImageV.x<self.view.width-_picImageV.width) {
            
            _picImageV.x += 0.1;
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _picImageV.x = self.view.width - _picImageV.width;
            } completion:^(BOOL finished) {
                
            }];
            
        }
    }
    
    if (self.view.height < _picImageV.height) {
        if (_picImageV.frame.origin.y>0) {
            _picImageV.y -= 0.1;
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _picImageV.y = 0;
            } completion:^(BOOL finished) {
                
            }];
        }
        if (_picImageV.y<self.view.height-_picImageV.height) {
            _picImageV.y += 0.1;
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:2 options:UIViewAnimationOptionCurveEaseIn animations:^{
                _picImageV.y=self.view.height-_picImageV.height;
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
}
-(void)pin:(UIPinchGestureRecognizer *)sender{
    CGFloat scale = sender.scale;
    CGPoint center = _picImageV.center;
    _picImageV.transform = CGAffineTransformScale(_picImageV.transform, scale, scale);
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (_picImageV.width<_Oframe.size.width) {
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                _picImageV.width = _Oframe.size.width;
                _picImageV.height = _Oframe.size.height;
                _picImageV.center = self.view.center;
            } completion:^(BOOL finished) {
                
            }];
        }
        if (_picImageV.width>_Oframe.size.width*3) {
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                _picImageV.width = _Oframe.size.width*3;
                _picImageV.height = _Oframe.size.height*3;
                _picImageV.center = center;
            } completion:^(BOOL finished) {
                
            }];
        }
        if (scale<1) {
            [self moveToCenter];
        }
    }
    
    sender.scale = 1;
}

-(void)moveToCenter{
    if (_picImageV.height<self.view.height) {
        CGFloat f = (self.view.center.y-_picImageV.center.y)/10;
        CGFloat x = _picImageV.center.x;
        CGFloat y = _picImageV.center.y;
        y += f;
        _picImageV.center = CGPointMake(x, y);
        [UIView animateWithDuration:0.3 animations:^{
            _picImageV.center = CGPointMake(x, self.view.center.y);
        } completion:nil];
        
        
    }
    
    if (_picImageV.width<self.view.width) {
        CGFloat f = (self.view.center.x-_picImageV.center.x)/10;
        CGFloat x = _picImageV.center.x;
        CGFloat y = _picImageV.center.y;
        x += f;
        _picImageV.center = CGPointMake(x, y);
        [UIView animateWithDuration:0.3 animations:^{
            _picImageV.center = CGPointMake(self.view.center.x, y);
        } completion:nil];
        
        
    }
}

- (IBAction)delete:(id)sender {
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"警告" message:@"删除后该照片将无法恢复，是否继续删除？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yes = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSInteger indext = [_phoA indexOfObject:_photo];
        if (indext == _phoA.count-1) {
            indext --;
        }
        if ([DBManagerTool deletePhoto:_photo type:_isSimi]) {
            [MBProgressHUD showSuccess:@"删除成功"];
        }
        [self resetMyView:indext];
    }];
    UIAlertAction *no = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:yes];
    [alertC addAction:no];
    [self presentViewController:alertC animated:YES completion:nil];
    
    
}
-(void)resetMyView:(NSInteger)indext{
    NSMutableArray *array = [NSMutableArray arrayWithArray:_phoA];
    [array removeObject:_photo];
    _phoA = [array copy];
    if (_phoA.count == 0) {
        if (self.navigationController.navigationBar.hidden == YES) {
            self.navigationController.navigationBar.hidden = NO;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        _photo = _phoA[indext];
        [self setImageV];
        [self resetView:indext];
    }

}
- (IBAction)putOut:(id)sender {
    UIImage *image = [UIImage imageWithData:_photo.content];
    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    [MBProgressHUD showSuccess:@"导出成功"];
}
- (IBAction)move:(id)sender {
    _selecC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"selectC"];
    _selecC.modalPresentationStyle = UIModalPresentationPopover;
    _selecC.popoverPresentationController.sourceView = _moveB;
    _selecC.popoverPresentationController.sourceRect = _moveB.bounds;
    _selecC.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    _selecC.popoverPresentationController.delegate = self;
    __weak typeof(self)weakSelf = self;
    _selecC.select = ^(NSString *kind){
        if ([kind isEqualToString:weakSelf.photo.photoKind]) {
            [MBProgressHUD show:@"已在该分组" icon:nil view:weakSelf.view];
            return ;
        }
        if ([DBManagerTool editPhotoGroup:kind oldName:weakSelf.photo.photoID type:weakSelf.isSimi]) {
            NSInteger indext = [weakSelf.phoA indexOfObject:weakSelf.photo];
            if (indext == _phoA.count-1) {
                indext --;
            }
            [weakSelf resetMyView:indext];
            [MBProgressHUD showSuccess:@"移动成功"];
        }
    };
    [self presentViewController:_selecC animated:YES completion:nil];
}
-(void)resetView:(NSInteger)indext{
    NSString *title = [NSString stringWithFormat:@"%ld/%lu",(long)indext+1,(unsigned long)_phoA.count];
    self.title = title;
}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    return UIModalPresentationNone;
}

- (IBAction)cutter:(id)sender {
    TOCropViewController *toc = [[TOCropViewController alloc] initWithImage:[UIImage imageWithData:_photo.content]];
    toc.delegate = self;
    [self presentViewController:toc animated:YES completion:nil];
}
-(void)cropViewController:(TOCropViewController *)cropViewController didCropToImage:(UIImage *)image withRect:(CGRect)cropRect angle:(NSInteger)angle{
    _picImageV.image = image;
    CGFloat s = self.view.width/image.size.width;
    self.picImageV.size = CGSizeMake(self.view.width,s*image.size.height);
    if (self.picImageV.height>self.view.height) {
        s = self.view.height/image.size.height;
        self.picImageV.size = CGSizeMake(_picImageV.width*s,self.view.height);
    }
    self.picImageV.center = self.view.center;
    UIImage *newImage = [self compactImage:image size:CGSizeMake(200, 200)];
    Photo *newPhoto = [Photo new];
    newPhoto.ID = _photo.ID;
    newPhoto.name = _photo.name;
    newPhoto.content = UIImageJPEGRepresentation(image, 0.5);
    newPhoto.smallContent = UIImageJPEGRepresentation(newImage, 1.0);
    newPhoto.size = [NSString stringWithFormat:@"%.0luKB",UIImageJPEGRepresentation(image, 1.0).length/1024];
    
    [DBManagerTool editPhoto:newPhoto oldPhoto:_photo type:_isSimi];
    [cropViewController dismissViewControllerAnimated:YES completion:nil];
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

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    _picImageV.hidden = YES;
}

- (IBAction)last:(id)sender {
    NSInteger indext = [_phoA indexOfObject:_photo];
    if (indext == 0) {
        [MBProgressHUD show:@"已经是第一张了" icon:nil view:self.view];
        return;
    }
    indext --;
    _photo = _phoA[indext];
    [self setImageV];
    [self resetView:indext];
}
- (IBAction)next:(id)sender {
    NSInteger indext = [_phoA indexOfObject:_photo];
    indext ++;
    if (indext > _phoA.count-1) {
        [MBProgressHUD show:@"已经是最后一张了" icon:nil view:self.view];
        return;
    }
    _photo = _phoA[indext];
    [self setImageV];
    [self resetView:indext];
    
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
