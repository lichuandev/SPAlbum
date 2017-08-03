//
//  Photo.h
//  SPAlbum
//
//  Created by Mac on 2017/6/2.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSData *content;
@property (nonatomic, copy) NSData *smallContent;
@property (nonatomic, copy) NSString *photoKind;
@property (nonatomic, copy) NSString *size;
@property (nonatomic, copy) NSString *photoID;
@end
