//
//  ThemeLabel.m
//  MyWbTest23
//
//  Created by Apple on 16/2/27.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"


@implementation ThemeLabel

#pragma mark - init

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (instancetype)initWithColorName:(NSString *)colorName{
    self = [self init];
    if (self != nil) {
        self.colorName = colorName;
    }
    return self;
}

#pragma mark - set

- (void)setColorName:(NSString *)colorName{
    if (_colorName != colorName) {
        _colorName = [colorName copy];
    }
    [self setColor];
}

- (void)setColor{
    self.textColor = [[ThemeManager shareInstance] getColorWithName:_colorName];
}

- (void)themeNotification:(NSNotification *)notify{
    [self setColor];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
