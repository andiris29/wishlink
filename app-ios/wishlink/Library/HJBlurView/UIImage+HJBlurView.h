//
//  UIImage+HJBlurView.h
//  wishlink
//
//  Created by whj on 15/11/21.
//  Copyright © 2015年 edonesoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (HJBlurView)

- (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

@end
