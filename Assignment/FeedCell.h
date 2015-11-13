//
//  NSObject+FeedCell.h
//  Assignment
//
//  Created by Manoj Arun on 11/12/15.
//  Copyright © 2015 Cognizant. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

static NSString * const kCellID = @"FeedCell";

@interface FeedCell:UITableViewCell
{
     NSString *reuseID;
}
@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *descriptionLbl;

@property (nonatomic, strong) UIImageView *thumbImage;

@end
