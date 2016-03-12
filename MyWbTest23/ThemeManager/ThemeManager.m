//
//  ThemeManager.m
//  MyWbTest23
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "ThemeManager.h"

static ThemeManager *singleton = nil;

@implementation ThemeManager

#pragma mark - init

- (id)init{
    self = [super init];
    if (self) {
        NSString *themePath = [[NSBundle mainBundle] pathForResource:@"theme_list" ofType:@"plist"];
        self.themesPlist = [NSDictionary dictionaryWithContentsOfFile:themePath];
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        id themes = [ud objectForKey:kThemeName];
//        if (themes) {
        self.curThemeName = (NSString *)themes;
//        }else {
//            self.curThemeName = nil;
//        }
        
    }
    return self;
}

- (void)setCurThemeName:(NSString *)curThemeName{
    if (_curThemeName != curThemeName) {
        _curThemeName = [curThemeName copy];
    }
    
    NSString *themeDir = [self getThemePath];
    NSString *filePath = [themeDir stringByAppendingPathComponent:@"fontColor.plist"];
    NSDictionary *colorDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    self.fontColorPlist = colorDict;
}

#pragma mark - singleton

+ (ThemeManager *)shareInstance{
    if (singleton == nil) {
        
        // 同步锁
        @synchronized(self) {
            singleton = [[ThemeManager alloc] init];
        }
    }
    return singleton;
}

+ (id)copyWithTheme:(ThemeManager *)theme{
    return self;
}

#pragma mark - get data

- (UIColor *)getColorWithName:(NSString *)name{
    if (name.length == 0) {
        return nil;
    }
    
    NSString *rgbString = [self.fontColorPlist objectForKey:name];
    NSArray *rgbArray = [rgbString componentsSeparatedByString:@","];
    if (rgbArray.count == 3) {
        float r = [rgbArray[0] floatValue];
        float g = [rgbArray[1] floatValue];
        float b = [rgbArray[2] floatValue];
        UIColor *color = Color(r, g, b, 1);
        return color;
    }
    return nil;
}

- (NSString *)getThemePath{
    
    
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    if (_curThemeName == nil) {
        return resourcePath;
    }
    NSString *themePath = [self.themesPlist objectForKey:_curThemeName];
    
    return [resourcePath stringByAppendingPathComponent:themePath];
}

- (UIImage *)getThemeImage:(NSString *)imageName{
    
    if (imageName.length == 0) {
        return nil;
    }
    
    NSString *themePath = [self getThemePath];
    NSString *imagePath = [themePath stringByAppendingPathComponent:imageName];
    
    UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
    
    return img;
}

@end
