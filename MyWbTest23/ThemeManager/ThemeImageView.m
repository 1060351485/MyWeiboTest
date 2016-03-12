//
//  ThemeImage.m
//  MyWbTest23
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "ThemeImageView.h"
#import "ThemeManager.h"

@implementation ThemeImageView

#pragma mark - set

//@synthesize imageName;

- (void)setImageName:(NSString *)imageName{
    if (_imageName != imageName) {
        _imageName = [imageName copy];
    }
    [self loadThemeImage];
}

#pragma mark - init

- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
}

- (instancetype)initWithImageName:(NSString *)imagename{
    self = [self init];
    self.imageName = imagename;
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    }
    
    return self;
}


- (void)loadThemeImage{
    if (self.imageName.length == 0) {
        return;
    }
    UIImage *image = [[ThemeManager shareInstance] getThemeImage:self.imageName];
    image = [image stretchableImageWithLeftCapWidth:self.leftCapWidth topCapHeight:self.topCapHeight];
    self.image = image;
}

#pragma mark - notify

- (void)themeNotification:(NSNotification *)notify{
    [self loadThemeImage];
}


@end
