//
//  DBManagerTool.m
//  SPAlbum
//
//  Created by Mac on 2017/6/2.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "DBManagerTool.h"

@implementation DBManagerTool
+(FMDatabase *)sharedDataBase:(int)type{
    if (type == 0) {
        static FMDatabase *dataBase = nil;
        static dispatch_once_t onceTock;
        dispatch_once(&onceTock, ^{
            NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"SPAlbum.sqlite"];
            dataBase = [FMDatabase databaseWithPath:filePath];
            if ([dataBase open]) {
                BOOL isCreat = [dataBase executeUpdate:@"create table if not exists pho_kind (id interger primary key, kind_name text, password text)"];
                if (isCreat) {
                    NSLog(@"建表成功");
                }
                BOOL isC = [dataBase executeUpdate:@"create table if not exists pho (id integer primary key, name text, content blob, smallContent blob, kind text, size text, photoID text)"];
                if (isC) {
                    NSLog(@"建表成功");
                }
            }
        });
        [dataBase open];
        return dataBase;
    }else{
        static FMDatabase *dataBase = nil;
        static dispatch_once_t onceTock;
        dispatch_once(&onceTock, ^{
            NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"SIMISPAlbum.sqlite"];
            dataBase = [FMDatabase databaseWithPath:filePath];
            if ([dataBase open]) {
                BOOL isCreat = [dataBase executeUpdate:@"create table if not exists pho_kind (id interger primary key, kind_name text, password text)"];
                if (isCreat) {
                    NSLog(@"私密建表成功");
                }
                BOOL isC = [dataBase executeUpdate:@"create table if not exists pho (id integer primary key, name text, content blob, smallContent blob, kind text, size text, photoID text)"];
                if (isC) {
                    NSLog(@"私密建表成功");
                }
            }
        });
        [dataBase open];
        return dataBase;
    }
    
}

+(BOOL)insertPhotoKind:(PhotoKind *)photoKind type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    BOOL isSuccess = [db executeUpdate:@"insert into pho_kind (kind_name, password) values (?, ?)",photoKind.name,photoKind.password];
    if (isSuccess) {
        NSLog(@"插入成功");
    }
    [db close];
    return isSuccess;
}
+(BOOL)insertPhoto:(Photo *)photo type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    BOOL isSuccess = [db executeUpdate:@"insert into pho (name, content, smallContent, kind, size, photoID) values (?, ?, ?, ?, ?, ?)",photo.name,photo.content,photo.smallContent,photo.photoKind,photo.size,photo.photoID];
    if (isSuccess) {
        NSLog(@"插入成功");
    }
    [db close];
    return isSuccess;
}
+(NSArray *)getAllPhotoKinds:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    FMResultSet *set = [db executeQuery:@"select * from pho_kind"];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        PhotoKind *kind = [PhotoKind new];
        kind.ID = [set intForColumn:@"id"];
        kind.name = [set stringForColumn:@"kind_name"];
        kind.password = [set stringForColumn:@"password"];
        [array addObject:kind];
    }
    [db close];
    return [array copy];
}
+(NSArray *)getAllPhotos:(NSString *)kindName  type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    FMResultSet *set = [db executeQuery:@"select * from pho where kind = ?",kindName];
    NSMutableArray *array = [NSMutableArray array];
    while ([set next]) {
        Photo *pho = [Photo new];
        pho.ID = [set intForColumn:@"id"];
        pho.name = [set stringForColumn:@"name"];
        pho.content = [set objectForColumnName:@"content" ];
        pho.smallContent = [set objectForColumnName:@"smallContent"];
        pho.photoKind = [set stringForColumn:@"kind"];
        pho.size = [set stringForColumn:@"size"];
        pho.photoID = [set stringForColumn:@"photoID"];
        [array addObject:pho];
    }
    [db close];
    return array;
}
+(BOOL)deletePhotoKind:(PhotoKind *)kind  type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    BOOL issuccess = [db executeUpdate:@"delete from pho_kind where kind_name = ?",kind.name];
    if (issuccess) {
        NSLog(@"删除成功");
    }
    [db close];
    return issuccess;
}
+(BOOL)deletePhoto:(Photo *)photo type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    BOOL issuccess = [db executeUpdate:@"delete from pho where photoID = ?",photo.photoID];
    if (issuccess) {
        NSLog(@"删除成功");
    }
    [db close];
    return issuccess;
}
+(BOOL)deletePhotoUseKindName:(NSString *)kindName type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    BOOL issuccess = [db executeUpdate:@"delete from pho where kind = ?",kindName];
    if (issuccess) {
        NSLog(@"删除成功");
    }
    [db close];
    return issuccess;
}
+(BOOL)editPhotoKindName:(NSString *)newName oldName:(NSString *)oldName type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    BOOL isSuccess = [db executeUpdate:@"update pho_kind set kind_name = ? where kind_name = ?",newName,oldName];
    if (isSuccess) {
        NSLog(@"修改成功");
    }
    [db close];
    return isSuccess;
}
+(BOOL)editPhotoKindPassword:(NSString *)newPassword oldName:(NSString *)oldPassword type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    BOOL isSuccess = [db executeUpdate:@"update pho_kind set password = ? where password = ?",newPassword,oldPassword];
    if (isSuccess) {
        NSLog(@"修改成功");
    }
    [db close];
    return isSuccess;
}
+(BOOL)editPhotoName:(NSString *)newName oldName:(NSString *)photoID type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    BOOL isSuccess = [db executeUpdate:@"update pho set name = ? where photoID = ?",newName,photoID];
    if (isSuccess) {
        NSLog(@"修改成功");
    }
    [db close];
    return isSuccess;
}
+(BOOL)editPhotoGroup:(NSString *)newKind oldName:(NSString *)photoID type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    BOOL isSuccess = [db executeUpdate:@"update pho set kind = ? where photoID = ?",newKind,photoID];
    if (isSuccess) {
        NSLog(@"修改成功");
    }
    [db close];
    return isSuccess;
}
+(BOOL)editPhoto:(Photo *)newPhoto oldPhoto:(Photo *)oldPhoto type:(int)type{
    FMDatabase *db = [DBManagerTool sharedDataBase:type];
    BOOL isSuccess = [db executeUpdate:@"update pho set content = ? where photoID = ?",newPhoto.content,oldPhoto.photoID] && [db executeUpdate:@"update pho set smallContent = ? where photoID = ?",newPhoto.smallContent,oldPhoto.photoID] && [db executeUpdate:@"update pho set size = ? where photoID = ?",newPhoto.size,oldPhoto.photoID];
    if (isSuccess) {
        NSLog(@"修改成功");
    }
    [db close];
    return isSuccess;
}
@end
