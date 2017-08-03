//
//  DBManagerTool.h
//  SPAlbum
//
//  Created by Mac on 2017/6/2.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "PhotoKind.h"
#import "Photo.h"
@interface DBManagerTool : NSObject
+(FMDatabase *)sharedDataBase:(int)type;
//插入相册
+(BOOL)insertPhotoKind:(PhotoKind *)photoKind type:(int)type;
//插入相片
+(BOOL)insertPhoto:(Photo *)photo type:(int)type;
//读取相册
+(NSArray *)getAllPhotoKinds:(int)type;
//读取相片
+(NSArray *)getAllPhotos:(NSString *)kindName type:(int)type;
//删除相册
+(BOOL)deletePhotoKind:(PhotoKind *)kind type:(int)type;
//删除相片
+(BOOL)deletePhoto:(Photo *)photo type:(int)type;
//用分类名删除相片
+(BOOL)deletePhotoUseKindName:(NSString *)kindName type:(int)type;
//修改相册名字
+(BOOL)editPhotoKindName:(NSString *)newName oldName:(NSString *)oldName type:(int)type;
//修改相册密码
+(BOOL)editPhotoKindPassword:(NSString *)newPassword oldName:(NSString *)oldPassword type:(int)type;
//修改相片名字
+(BOOL)editPhotoName:(NSString *)newName oldName:(NSString *)oldName type:(int)type;
//修改相片所属分组
+(BOOL)editPhotoGroup:(NSString *)newKind oldName:(NSString *)oldName type:(int)type;
//修改相片图片
+(BOOL)editPhoto:(Photo *)newPhoto oldPhoto:(Photo *)oldPhoto type:(int)type;
@end
