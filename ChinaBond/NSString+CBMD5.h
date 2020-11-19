//
//  NSString+CBMD5.h
//  ChinaBond
//
//  Created by wangran on 15/12/17.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (CBMD5)

- (NSString *) CBMD5Hash8;
- (NSString *) CBMD5Hash32;

@end
