//
//  CBChannelModel.m
//  ChinaBond
//
//  Created by wangran on 15/12/24.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBChannelModel.h"

@implementation CBChannelModel

-(NSMutableArray *)childrens
{
    if (!_childrens) {
        _childrens = [[NSMutableArray alloc] initWithCapacity:100];
    }
    return _childrens;
}

@end
