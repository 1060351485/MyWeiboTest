//
//  RectButton.m
//  MyWbTest23
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "RectButton.h"

@implementation RectButton

- (void)layoutSubviews{

    self.titleLabel.text = @"";
    
    self.title.frame = CGRectMake((self.width-self.title.width)/2, self.height/4*3-self.title.height/2, 30, 10);
    self.title.userInteractionEnabled = YES;
    [self addSubview:self.title];

    self.subtitle.frame = CGRectMake((self.width-self.title.width)/2, self.height/4-self.title.height/2, 30, 10);
    self.title.userInteractionEnabled = YES;
    [self addSubview:self.title];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
