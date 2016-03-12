//
//  UIFactory.m
//  MyWbTest23
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "UIFactory.h"

@implementation UIFactory

+ (ThemeButton *)createButton:(NSString *)imageName highlighted:(NSString *)highlightedName{
    
    ThemeButton *btn = [[ThemeButton alloc] initWithImage:imageName highlightedImage:highlightedName];
    return btn;
}

+ (ThemeButton *)createButtonWithBackground:(NSString *)backgroundImageName highlighted:(NSString *)backgoundHighlightedName{
    
    ThemeButton *btn = [[ThemeButton alloc] initWithBGImage:backgroundImageName highlightedBGImage:backgoundHighlightedName];
    return btn;
}

+ (ThemeImageView *)createImageView:(NSString *)imageName{
    ThemeImageView *imageView = [[ThemeImageView alloc] initWithImageName:imageName];
    return imageView;
}

+ (ThemeLabel *)createLabel:(NSString *)colorName{
    ThemeLabel *label = [[ThemeLabel alloc] initWithColorName:colorName];
    return label;
}

@end
