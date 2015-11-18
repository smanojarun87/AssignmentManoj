//
//  ViewController.m
//  Assignment
//
//  Created by Manoj Arun on 11/12/15.
//  Copyright © 2015 Cognizant. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (void)viewDidLoad {
    
    // Init the view with the bounds and background as white color.
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Invoke the NSURLConnection and parse the JSON data.
    [self triggerFeedURL];
    
    [super viewDidLoad];
}

- (void)triggerFeedURL
{
    // Create the NSURLRequest.
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:jsonUrl]];
    
    // Url connection is created and the request will be fired.
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (conn == nil) {
        [SharedUtil showAlert:@"Error":@"Something went wrong in connection! Please try again."];
    }
}

// To refresh the feed table data.
-(void)refreshTableView{
    
    [tableView reloadData];
}

// Show the feeds with the json request data.
-(void)showFeed:(NSData*)reqData{
    
    NSString *responseStr = [[NSString alloc] initWithData:reqData encoding:NSASCIIStringEncoding];
    
    // If the request data return nil or empty , it will throw the error.
    if( responseStr )
    {
        NSError *e;
        NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        
        // Get the NSdata and store in the NSDictionary
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
        
        if (jsonDict) {

            // Get the title from Json response as string
            self.sectionTitle = [jsonDict objectForKey:@"title"];
            
            // Get the array from the feeds such as title , description and image url
            NSArray *rows = [jsonDict objectForKey:@"rows"];
            
            // Init the feed Model
            feed= [[FeedModel alloc ]init];
 
            // Iterate the array and store in the FeedModel Object
            for (NSDictionary *item in rows) {
                 
                [feed.title addObject:[item objectForKey:@"title"]];
                [feed.descriptionFeed addObject:[item objectForKey:@"description"]];
                [feed.imageHref addObject:[item objectForKey:@"imageHref"]];
            }
            
            // init table view
            tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, (self.view.bounds.origin.y+20), self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
            
            // set delegate & dataSource
            tableView.delegate = self;
            tableView.dataSource = self;
            
            // Register the class to identity the custom cell
            [tableView registerClass:[FeedCell class] forCellReuseIdentifier:kCellID];
            // Selection of row is disabled
            tableView.allowsSelection = NO;
            // Auto resize for portrait and landscape width and height
            tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            // add to canvas
            [self.view addSubview:tableView];
            
            // Add the refresh button in the view.
            UIButton *refreshBut = [UIButton buttonWithType:UIButtonTypeCustom];
            [refreshBut addTarget:self
                           action:@selector(refreshTableView)
                 forControlEvents:UIControlEventTouchUpInside];
            [refreshBut setBackgroundImage:[UIImage imageNamed:@"refreshImage"] forState:UIControlStateNormal];
            [refreshBut setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.view addSubview:refreshBut];
            
            // Autolayout constraints for Refresh Button
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[refreshBut(35)]-8-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(refreshBut)];
            [self.view addConstraints:constraints];
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-28-[refreshBut(35)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(refreshBut)]];
        }else{
            NSLog(@"Not a valid JSON :  %@",e);
        }
    }
    else
    {
        [SharedUtil showAlert:@"Error":@"Error in loading JSON from url. Please try again!"];
    }
    
}

// Delegate method. Table view is reloaded when the user rotate the orientation.
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [tableView reloadData];
}

// iOS8 doesn't show the status bar in landscape.To show the status bar the default method is overwritten.
- (BOOL)prefersStatusBarHidden {
    return NO;
}

#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

// Header title for the table
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.sectionTitle;
}

// Default view for the header is overwritten with the style.
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = self.sectionTitle;
    
    // Label with section title
    UILabel *label = [[UILabel alloc] init] ;
    label.frame = CGRectMake(8, 0, self.view.bounds.size.width, 50);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Verdana" size:24];
    label.textColor = [UIColor darkGrayColor];
    label.text = sectionTitle;
    label.backgroundColor = [UIColor clearColor];
    
    // Header view and label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view addSubview:label];
    
    return view;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [feed.title count];
}

// the cell will be returned to the tableView
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    // UITableViewCell
    FeedCell *cell = (FeedCell *)[theTableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[FeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Condition to handle the title is null and if not will display in the feed
    if (![feed.title[indexPath.row] isEqual:[NSNull null]])
        cell.titleLbl.text = feed.title[indexPath.row];
    else
        cell.titleLbl.text = @"None";

    // Condition to handle the description feed is null and if not will display in the feed
    if (![feed.descriptionFeed[indexPath.row] isEqual:[NSNull null]])
        cell.descriptionLbl.text = feed.descriptionFeed[indexPath.row];
    else
        cell.descriptionLbl.text = @"None";

    // Condition to handle the image url is null and if not will display the image in the feed
    if (![feed.imageHref[indexPath.row] isEqual:[NSNull null]]) {
        
        // Default image will set and it will be replaced once the image is downloaded. Because some of the urls are not working.
        cell.thumbImage.image = [UIImage imageNamed:@"noImage"];
        
        NSURL *url = [NSURL URLWithString:feed.imageHref[indexPath.row]];
        
        // Block to handle the image downloading and load in to the table once received the data from the URL. If no no image will be displyed
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * __nullable reqdata, NSURLResponse * __nullable reqResponse, NSError * __nullable error) {
            if (reqdata) {
                UIImage *image = [UIImage imageWithData:reqdata];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        FeedCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                            updateCell.thumbImage.image = [SharedUtil resizeImage:image];
                        else
                            updateCell.thumbImage.image = [UIImage imageNamed:@"noImage"];
                    });
                }
                else{
                    NSLog(@"Error loading the image from URL : %@",error);
                }
            }
        }];
        [task resume];
    }else{
        cell.thumbImage.image = [UIImage imageNamed:@"noImage"];
    }
    
    return cell;
}

// Height for header section
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50.0f;
}

// It's delegate method of UITableView and the logic to be handle for different height of the row based on desc text.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize labelHeight;
    NSDictionary *filter = self.rowData[indexPath.row];
    NSString *descText = [filter objectForKey:@"description"];
    if (![descText isEqual:[NSNull null]]) {
        UIFont *font = [UIFont fontWithName:@"Verdana" size:18];
        labelHeight = [SharedUtil heigtForCellwithString:descText withFont:font];
        if (labelHeight.height>=rowHeight) {
            return labelHeight.height;
        }else{
            rowHeight = (rowHeight-(labelHeight.height))+labelHeight.height;
            return rowHeight;
        }
    }
    else{
        return rowHeight;
    }
}

// This method used to display the backgorund gradient color.
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setBackgroundColor:[UIColor clearColor]];
    
    CAGradientLayer *grad = [CAGradientLayer layer];
    grad.frame = cell.bounds;
    grad.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    
    [cell setBackgroundView:[[UIView alloc] init]];
    [cell.backgroundView.layer insertSublayer:grad atIndex:0];
    
}

#pragma mark - UITableViewDelegate
// when user tap the row, what action you want to perform
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"selected %ld row", (long)indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    
    [self showFeed:_responseData];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    if (error.code == NSURLErrorTimedOut) {
        [SharedUtil showAlert:@"Error":[error localizedDescription]];
    }else if(error.code == NSURLErrorNetworkConnectionLost){
        [SharedUtil showAlert:@"Error":[error localizedDescription]];
    }else if(error.code == NSURLErrorUnknown){
        [SharedUtil showAlert:@"Error":[error localizedDescription]];
    }else if (error.code==NSURLErrorCancelled){
        [SharedUtil showAlert:@"Error":[error localizedDescription]];
    }else{
        [SharedUtil showAlert:@"Error":@"Something went wrong in connection! Please try again."];
    }
}

@end
