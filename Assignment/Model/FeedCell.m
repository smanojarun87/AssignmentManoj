//
//  NSObject+FeedCell.m
//  Assignment
//
//  Created by Manoj Arun on 11/12/15.
//  Copyright © 2015 Cognizant. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell

@synthesize titleLbl,descriptionLbl,thumbImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        reuseID = reuseIdentifier;
        
        titleLbl = [[UILabel alloc] init];
        titleLbl.numberOfLines = 0;
        titleLbl.lineBreakMode = NSLineBreakByWordWrapping;
        [titleLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
        [titleLbl setFont:[UIFont fontWithName:@"Verdana" size:19]];
        [titleLbl setTextColor:[UIColor purpleColor]];
        titleLbl.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
        [self.contentView addSubview:titleLbl];
        
        descriptionLbl = [[UILabel alloc] init];
        descriptionLbl.numberOfLines = 0;
        descriptionLbl.lineBreakMode = NSLineBreakByWordWrapping;
        [descriptionLbl setTranslatesAutoresizingMaskIntoConstraints:NO];
        [descriptionLbl setFont:[UIFont fontWithName:@"Verdana" size:14]];
        descriptionLbl.preferredMaxLayoutWidth = CGRectGetWidth(self.bounds);
        [descriptionLbl setTextColor:[UIColor darkGrayColor]];
        
        [self.contentView addSubview:descriptionLbl];
        
        thumbImage = [[UIImageView alloc] init];
        [thumbImage setTranslatesAutoresizingMaskIntoConstraints:NO];
        [thumbImage setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [thumbImage setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.contentView addSubview:thumbImage];
        
        
        NSDictionary *views = NSDictionaryOfVariableBindings(titleLbl, descriptionLbl,thumbImage);
        
        // Autolayout constraints for Title label
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[titleLbl]-8-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views];
        [self addConstraints:constraints];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-2-[titleLbl]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLbl)]];
        
        // Autolayout constraints for Description label
        NSArray* constrs = [NSLayoutConstraint constraintsWithVisualFormat:@"|-8-[descriptionLbl]-108-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(descriptionLbl)];
        [self addConstraints:constrs];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-28-[descriptionLbl]-2-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(descriptionLbl)]];
        
        
        // Autolayout constraints for Image
        NSArray *imagconstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[thumbImage]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:views];
        [self addConstraints:imagconstraints];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[thumbImage]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(thumbImage)]];
        
    }
    
    return self;
}

@end
