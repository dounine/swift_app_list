//
//  UIImage+Ext.h
//  swift_app_list
//
//  Created by lake on 2024/8/12.
//
#import <UIKit/UIKit.h>

@interface UIImage (Private)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(NSUInteger)format scale:(CGFloat)scale;
@end
