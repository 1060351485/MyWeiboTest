//
//  UIView+GetController.m
//  MyWbTest23
//
//  Created by Apple on 16/3/11.
//  Copyright © 2016年 JohnHe. All rights reserved.
//

#import "UIView+GetController.h"

@implementation UIView (GetController)

- (UIViewController *)viewController{
    
    UIResponder *responder = self.nextResponder;
    do {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = responder.nextResponder;
    } while (responder);
    
    return nil;
}

@end
