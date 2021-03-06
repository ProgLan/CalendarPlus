//
//  Utils.m
//  CalendarPlus
//
//  Created by Howon Song on 11/10/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import "Utils.h"

@implementation Utils

// Assumes input like "#00FF00" (#RRGGBB).
- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

- (UIImage *)imageWithColor:(UIColor *)color buttonWidth:(float)bw buttonHeight:(float)bh fillHeight:(float)fh {
    CGRect rect = CGRectMake(0, 0, bw, bh);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGRect innerRect = CGRectMake(0 , bh - fh, bw, fh);
    [color setFill];
    UIRectFill(innerRect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
