//
//  TableViewFooterView.m
//  SPAlbum
//
//  Created by Mac on 2017/6/2.
//  Copyright © 2017年 Mac. All rights reserved.
//

#import "TableViewFooterView.h"

@implementation TableViewFooterView
- (IBAction)buttonClick:(id)sender {
    [self.delegate addKinds];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
