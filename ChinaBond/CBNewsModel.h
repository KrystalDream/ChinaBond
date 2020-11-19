//
//  CBNewsModel.h
//  ChinaBond
//
//  Created by wangran on 15/12/21.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CBNewsModel : NSObject
//重点关注名称
@property (nonatomic, copy) NSString *cName;
//重点关注图片地址
@property (nonatomic, copy) NSString *imgUrl;
//重点关注详情url
@property (nonatomic, copy) NSString *infoUrl;
//重点关注id
@property (nonatomic, copy) NSString *tId;
//重点关注标题
@property (nonatomic, copy) NSString *title;
//重点关注时间
@property (nonatomic, copy) NSString *vTime;
@end
