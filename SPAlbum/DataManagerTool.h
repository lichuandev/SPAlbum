//
//  DataManagerTool.h
//  SPAlbum
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManagerTool : NSObject
+(instancetype)sharedDataManagetTool;
//正则判断密码是否符合规则
-(BOOL)judgemetPasswordIsRight:(NSString *)string;
//正则判断相册密码是否符合规则
-(BOOL)judgemetAlbumPasswordIsRight:(NSString *)string;
//获取时间差
-(NSTimeInterval)getTimeIntervals:(NSString *)dateS;
//获取时间字符串
-(NSString *)getDateS:(NSDate *)date;
//获取时间
-(NSDate *)getCurrentDate:(NSString *)dateS;

// 标识是否私密相册
-(void)setSimi:(int)isSimi;
-(BOOL)getIsSimi;

-(void)setPhotos:(NSArray *)phoA;
-(NSArray *)getPhotos;
@end
