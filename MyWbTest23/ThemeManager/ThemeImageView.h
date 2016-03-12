//
//  ThemeImage.h
//  MyWbTest23
//
//  Created by Apple on 16/2/26.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeImageView : UIImageView

@property (nonatomic, copy) NSString *imageName;
@property(nonatomic) int leftCapWidth;
@property(nonatomic) int topCapHeight;


- (instancetype)initWithImageName:(NSString *)imageName;

@end
