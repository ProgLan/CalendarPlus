//
//  Utils.h
//  CalendarPlus
//
//  Created by Howon Song on 11/10/14.
//  Copyright (c) 2014 Howon Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

- (UIColor *)colorFromHexString:(NSString *)hexString;

- (UIImage *)imageWithColor:(UIColor *)color buttonWidth:(float)bw buttonHeight:(float)bh fillHeight:(float)fh;

@end
