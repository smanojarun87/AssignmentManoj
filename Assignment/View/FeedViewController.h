//
//  ViewController.h
//  Assignment
//
//  Created by Manoj Arun on 11/12/15.
//  Copyright © 2015 Cognizant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeedCell.h"
#import "SharedUtil.h"
#import "FeedModel.h"

// Default row height of the feed table.
static int rowHeight = 110;
// Json response from the URL.
static NSString *jsonUrl = @"https://dl.dropboxusercontent.com/u/746330/facts.json";

@interface FeedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnectionDelegate>
{
    UITableView *tableView;
    NSMutableData *_responseData;
    FeedModel *feed;
}

@property (nonatomic, strong) NSMutableArray *rowData;// Feed data from the json array of "rows":[]
@property (nonatomic, strong) NSString *sectionTitle; // Section title "title":""

@end

