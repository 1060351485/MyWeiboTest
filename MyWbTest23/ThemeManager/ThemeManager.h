//
//  ThemeManager.h
//  MyWbTest23
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kThemeDidChangeNotification @"kThemeDidChangeNotification"

@interface ThemeManager : NSObject

@property (nonatomic, retain) NSString *curThemeName;
@property (nonatomic, retain) NSDictionary *themesPlist;
@property (nonatomic, retain) NSDictionary *fontColorPlist;

+ (ThemeManager *)shareInstance;

- (UIColor *)getColorWithName:(NSString *)name;

- (UIImage *)getThemeImage:(NSString *)imageName;

@end
