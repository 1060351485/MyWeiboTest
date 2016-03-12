//
//  RectButton.h
//  MyWbTest23
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RTLabel.h"

@interface RectButton : UIButton

@property (nonatomic, weak) UILabel *title;
@property (nonatomic, weak) RTLabel *subtitle;

@end
