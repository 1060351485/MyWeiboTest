//
//  ThemeButton.h
//  MyWbTest23
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeButton : UIButton

@property (nonatomic ,copy) NSString *imageName;
@property (nonatomic ,copy) NSString *imageHLName;

@property (nonatomic, copy) NSString *imageBG; // background
@property (nonatomic, copy) NSString *imageHLBG; //highlight

- (id)initWithImage:(NSString *)imageName  highlightedImage:(NSString *)highlightedImage;
- (id)initWithBGImage:(NSString *)bgImageName highlightedBGImage:(NSString *)highlightedBGImage;
@end
