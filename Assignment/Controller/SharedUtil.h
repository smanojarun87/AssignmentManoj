//
//  ViewController.h
//  Assignment
//
//  Created by Manoj Arun on 18/12/15.
//  Copyright © 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharedUtil : NSObject

+ (SharedUtil *) instance;
+ (UIImage*)resizeImage:(UIImage*)image;
+ (CGSize)heigtForCellwithString:(NSString *)stringValue withFont:(UIFont*)font;
+ (void)showAlert:(NSString *)errorTitle :(NSString *)errorMessage;

@end
