//
//  NetworkUtil.m
//  wepa
//
//  Created by Developer iPhone on 28/04/12.
//  Copyright (c) 2012 My Company. All rights reserved.
//

#import "SharedUtil.h"


@implementation SharedUtil
static SharedUtil *instance=nil;

-(id) init {
    self = [super init];
    return self;
}
+(SharedUtil *) instance{
    
    if (!instance) {
        instance=[SharedUtil new];
    }
    return instance;
}

// To display the thumbnail size of images - Orginal images are resized to 85x85.
+(UIImage*)resizeImage:(UIImage*)image{
    CGSize destinationSize = CGSizeMake(85, 85);
    UIGraphicsBeginImageContext(destinationSize);
    [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImage;
}

// From the feed description the height of the row would be calculated.
+(CGSize)heigtForCellwithString:(NSString *)stringValue withFont:(UIFont*)font{
    CGSize constraint = CGSizeMake(294,9999);
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [stringValue boundingRectWithSize:constraint
                                            options:         (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil];
    return rect.size;
    
}

+(void)showAlert:(NSString *)errorTitle :(NSString *)errorMessage{
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:errorTitle message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

@end