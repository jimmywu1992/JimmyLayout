//
//  photoCollectionViewCell.m
//  JP
//
//  Created by wjpMac on 16/5/26.
//  Copyright © 2016年 wjpMac. All rights reserved.
//

#import "photoCollectionViewCell.h"

@implementation photoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    
    
    if (self = [super initWithFrame:frame]) {
       _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height)];
       
        [self.contentView addSubview:_image];
        
        
    }
    return self;
    
}
@end
