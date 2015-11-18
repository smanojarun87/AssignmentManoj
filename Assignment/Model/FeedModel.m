//
//  NSObject+FeedModel.h
//  Assignment
//
//  Created by Manoj Arun on 11/17/15.
//  Copyright © 2015 Cognizant. All rights reserved.
//

#import "FeedModel.h"

@implementation FeedModel

@synthesize title,descriptionFeed,imageHref;

-(id)init{
    self = [super init];
    
    title =  [[NSMutableArray alloc]init];
    
    descriptionFeed =  [[NSMutableArray alloc]init];
    
    imageHref =  [[NSMutableArray alloc]init];
    
    return self;
}

@end
