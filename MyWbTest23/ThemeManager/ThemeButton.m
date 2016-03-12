//
//  ThemeButton.m
//  MyWbTest23
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "ThemeButton.h"
#import "ThemeManager.h"

@implementation ThemeButton

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (id)initWithImage:(NSString *)imageName  highlightedImage:(NSString *)highlightedImage{
    self = [self init];
    if (self) {
        self.imageName = imageName;
        self.imageHLName = highlightedImage;
    }
    return self;
}

- (id)initWithBGImage:(NSString *)bgImageName highlightedBGImage:(NSString *)highlightedBGImage{
    self = [self init];
    if (self) {
        self.imageBG = bgImageName;
        self.imageHLBG = highlightedBGImage;
    }
    return self;
}

- (void)setImageName:(NSString *)imageName{
    if (_imageName != imageName) {
        _imageName = [imageName copy];
    }
    [self loadThemeImage];
}

- (void)setImageHLName:(NSString *)imageHLName{
    if (_imageHLName != imageHLName) {
        _imageHLName = [imageHLName copy];
    }
    [self loadThemeImage];
}

- (void)setImageBG:(NSString *)imageBG{
    if (_imageBG != imageBG) {
        _imageBG = [imageBG copy];
    }
    [self loadThemeImage];
}

- (void)setImageHLBG:(NSString *)imageHLBG{
    if (_imageHLBG != imageHLBG) {
        _imageHLBG = [imageHLBG copy];
    }
    [self loadThemeImage];
}

- (void)loadThemeImage{
    ThemeManager *themeManager = [ThemeManager shareInstance];
    
    UIImage *image = [themeManager getThemeImage:_imageName];
    UIImage *highlightImage = [themeManager getThemeImage:_imageHLName];
    UIImage *bgImage = [themeManager getThemeImage:_imageBG];
    UIImage *bgHLImage = [themeManager getThemeImage:_imageHLBG];
    
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:highlightImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:bgImage forState:UIControlStateNormal];
    [self setBackgroundImage:bgHLImage forState:UIControlStateHighlighted];
}

- (void)themeNotification:(NSNotification *)notify{
    [self loadThemeImage];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
