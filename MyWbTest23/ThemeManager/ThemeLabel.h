//
//  ThemeLabel.h
//  MyWbTest23
//
//  Created by Apple on 16/2/27.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeLabel : UILabel

@property (nonatomic, copy) NSString *colorName;


- (instancetype)initWithColorName:(NSString *)colorName;
@end
