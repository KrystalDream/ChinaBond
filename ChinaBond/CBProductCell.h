//
//  CBProductCell.h
//  ChinaBond
//
//  Created by wangran on 15/12/15.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBProductCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UILabel *productName;
@property (strong, nonatomic) IBOutlet UILabel *productNum;
@property (strong, nonatomic) IBOutlet UIImageView *productColor;
@property (strong, nonatomic) IBOutlet UILabel *productLevel;

@end
