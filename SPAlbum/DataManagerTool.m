//
//  DataManagerTool.m
//  SPAlbum
//
//  Created by Mac on 2017/6/1.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "DataManagerTool.h"

@implementation DataManagerTool
static DataManagerTool *dataManagerTool = nil;
+(instancetype)sharedDataManagetTool{
    static dispatch_once_t onceTock;
    dispatch_once(&onceTock, ^{
        dataManagerTool = [[DataManagerTool alloc] init];
    });
    return dataManagerTool;
}
-(BOOL)judgemetPasswordIsRight:(NSString *)string{
    NSString *number = @"^[a-zA-a]\\w{5,15}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [pre evaluateWithObject:string];
}
-(BOOL)judgemetAlbumPasswordIsRight:(NSString *)string{
    NSString *number = @"^[0-9]{4}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",number];
    return [predicate evaluateWithObject:string];
}
-(NSTimeInterval)getTimeIntervals:(NSString *)dateS{
    NSDate *current = [NSDate date];
    NSDate *date = [self getCurrentDate:dateS];
    NSTimeInterval times = [current timeIntervalSinceDate:date];
    return times;
}
-(NSString *)getDateS:(NSDate *)date{
    NSDateFormatter *dateFormatter = [self getDateFormatter];
    NSString *dates = [dateFormatter stringFromDate:date];
    return dates;
}
-(NSDate *)getCurrentDate:(NSString *)dateS{
    NSDateFormatter *dateFormatter = [self getDateFormatter];
    NSDate *date = [dateFormatter dateFromString:dateS];
    return date;
}
static NSDateFormatter *dateFormatter = nil;
-(NSDateFormatter *)getDateFormatter{
    static dispatch_once_t onceTock;
    dispatch_once(&onceTock, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    });
    return dateFormatter;
}
static int _isSimi;
-(void)setSimi:(int)isSimi{
    _isSimi = isSimi;
}
-(BOOL)getIsSimi{
    return _isSimi;
}
static NSArray *array;
-(void)setPhotos:(NSArray *)phoA{
    array = phoA;
}
-(NSArray *)getPhotos{
    return array;
}
@end
