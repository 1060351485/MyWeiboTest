//
//  UIFactory.h
//  MyWbTest23
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"
#import "ThemeImageView.h"
#import "ThemeLabel.h"

@interface UIFactory : NSObject

+ (ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName;
+ (ThemeButton *)createButtonWithBackground:(NSString *)backgroundImageName highlighted:(NSString *)backgoundHighlightedName;

+ (ThemeImageView *)createImageView:(NSString *)imageName;

+ (ThemeLabel *)createLabel:(NSString *)colorName;
@end
