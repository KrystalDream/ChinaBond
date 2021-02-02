//
//  CBHomeItemCell.m
//  ChinaBond
//
//  Created by wangran on 15/12/3.
//  Copyright © 2015年 chinaBond. All rights reserved.
//

#import "CBHomeItemCell.h"
#import "CBItemButton.h"
//#import "UIView+STFrame.h"

@implementation CBHomeItemCell

+(CBHomeItemCell *)homeItemCell
{
    CBHomeItemCell * cell = [[[NSBundle mainBundle] loadNibNamed:@"CBHomeItemCell" owner:self options:nil] objectAtIndex:0];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)awakeFromNib {
    
//    NSArray * nameArr = [CBCacheManager shareCache].gdChannelArr;
//    
//    
//    CGFloat tmpFloat = SCREEN_WIDTH/4;
//    
//
//    for (int i =0; i<4; i++) {
//        for (int j=0; j<2; j++) {
//            
//            if (nameArr.count == i+j*4) {
//                return;
//            }
//            
//            CBItemButton *item = [[CBItemButton alloc] initWithFrame:CGRectMake(tmpFloat *i, 5*(j+1)+75*j, SCREEN_WIDTH/4, 75)
//                                                    andImage:[NSString stringWithFormat:@"home_%@",nameArr[i+j*4][@"typeId"]]
//                                                    andTitle:nameArr[i+j*4][@"name"]];
//            
//            item.tag = i+j*4;
//            
//            item.clickBlock = ^(NSInteger tag){
//                [self.delegate choseChannel:tag];
//            };
//            [self.contentView addSubview:item];
//        }
//    }

}

- (void)reloaData
{
    NSArray * nameArr = [[CBCacheManager shareCache] getCache];
    
    for (CBItemButton *item in self.contentView.subviews) {
        [item removeFromSuperview];
    }
    
//    CGFloat tmpFloat = SCREEN_WIDTH/4;
    
    if (nameArr.count>0) {
        /*
        for (int j=0; j<2; j++) {
            for (int i =0; i<4; i++) {
                
                if (nameArr.count == i+j*4) {
                    return;
                }
                
                CBItemButton *item = [[CBItemButton alloc] initWithFrame:CGRectMake(tmpFloat *i, 5*(j+1)+75*j, SCREEN_WIDTH/4, 75)
                                                                andImage:[NSString stringWithFormat:@"home_%@",nameArr[i+j*4][@"typeId"]]
                                                                andTitle:nameArr[i+j*4][@"name"]
                                                                andIndex:i+j*4
                                                                  andDic:nameArr[i+j*4]];
                item.tag = i+j*4;
                
                item.clickBlock = ^(NSInteger tag){
                    [self.delegate choseChannel:nameArr[tag]];
                };
                [self.contentView addSubview:item];
            }
        }
         */
        
        int  lineCount = 4;
        float width =  SCREEN_WIDTH/lineCount;
        for(int i = 0; i < nameArr.count ; i++){
            CBItemButton *item = [[CBItemButton alloc] initWithFrame : CGRectMake(width*(i%lineCount),  5 + i/lineCount *(75 + 5), width, 75)
                                                            andImage : [NSString stringWithFormat:@"home_%@",nameArr[i][@"typeId"]]
                                                            andTitle : nameArr[i][@"name"]
                                                            andIndex : i
                                                              andDic : nameArr[i]];
            item.tag = i;
            item.clickBlock = ^(NSInteger tag){
                [self.delegate choseChannel:nameArr[tag]];
            };
            [self.contentView addSubview:item];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
