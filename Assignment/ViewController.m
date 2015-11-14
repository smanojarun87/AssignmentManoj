//
//  ViewController.m
//  Assignment
//
//  Created by Manoj Arun on 11/12/15.
//  Copyright © 2015 Cognizant. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    
    // parse the json from url and initiate to load the data in to tableview.
    [self jsonParsingandLoadData];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)jsonParsingandLoadData
{
    NSURL *reqUrl = [[NSURL alloc ]initWithString:jsonUrl];
    
    NSError* error = nil;
    NSString* responseStr = [NSString stringWithContentsOfURL:reqUrl encoding:NSASCIIStringEncoding error:&error];
    
    if( responseStr )
    {
        NSData *jsonData = [responseStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
        
        if (jsonDict) {
            
            self.rowData = [[NSMutableArray alloc]init];
            self.rowData = [jsonDict objectForKey:@"rows"];
            self.sectionTitle = [jsonDict objectForKey:@"title"];
            
            // init table view
            tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, (self.view.bounds.origin.y+20), self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
            
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
            
            
            UIButton *refreshBut = [UIButton buttonWithType:UIButtonTypeCustom];
            [refreshBut addTarget:self
                           action:@selector(refreshTableView)
                 forControlEvents:UIControlEventTouchUpInside];
            [refreshBut setBackgroundImage:[UIImage imageNamed:@"refresh.png"] forState:UIControlStateNormal];
            [refreshBut setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.view addSubview:refreshBut];
            
            // Autolayout constraints for Refresh Button
            NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[refreshBut(32)]-8-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(refreshBut)];
            [self.view addConstraints:constraints];
            
            [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[refreshBut(32)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(refreshBut)]];
        }else{
            NSLog(@"Not a valid JSON :  %@",e);
        }
        
        
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:@"Error in loading JSON from url. Please try again!"
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        
        [alert show];
    }
}

// To refresh the feed table data.
-(void)refreshTableView{
    
    [tableView reloadData];
}

#pragma mark - UITableViewDataSource
// number of section(s), now I assume there is only 1 section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.sectionTitle;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = self.sectionTitle;
    
    // Label with section title
    UILabel *label = [[UILabel alloc] init] ;
    label.frame = CGRectMake(8, 0, self.view.bounds.size.width, 23);
    label.textColor = [UIColor blackColor];
    label.font = [UIFont fontWithName:@"Verdana" size:24];
    label.textColor = [UIColor darkGrayColor];
    label.text = sectionTitle;
    label.backgroundColor = [UIColor whiteColor];
    
    // Header view and label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [view addSubview:label];
    
    return view;
}

// number of row in the section, I assume there is only 1 row
- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    return [self.rowData count];
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
    
    NSDictionary *filter = self.rowData[indexPath.row];
    
    NSString *titleText = [filter objectForKey:@"title"];
    NSString *descText = [filter objectForKey:@"description"];
    
    if (![titleText isEqual:[NSNull null]])
        cell.titleLbl.text = titleText;
    else
        cell.titleLbl.text = @"None";
    
    if (![descText isEqual:[NSNull null]])
        cell.descriptionLbl.text = descText;
    else
        cell.descriptionLbl.text = @"None";

    if (![[filter objectForKey:@"imageHref"] isEqual:[NSNull null]]) {
        
        // Default image will set and it will be replaced once the image is downloaded. Because some of the urls are not working.
        cell.thumbImage.image = [UIImage imageNamed:@"No_Image.png"];
        
        NSURL *url = [NSURL URLWithString:[filter objectForKey:@"imageHref"]];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * __nullable reqdata, NSURLResponse * __nullable reqResponse, NSError * __nullable error) {
            if (reqdata) {
                UIImage *image = [UIImage imageWithData:reqdata];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        FeedCell *updateCell = (id)[tableView cellForRowAtIndexPath:indexPath];
                        if (updateCell)
                            updateCell.thumbImage.image = [self resizeImage:image];
                        else
                            updateCell.thumbImage.image = [UIImage imageNamed:@"No_Image.png"];
                    });
                }
                else{
                    NSLog(@"Error loading the image from URL : %@",error);
                }
            }
        }];
        [task resume];
    }else{
        cell.thumbImage.image = [UIImage imageNamed:@"No_Image.png"];
    }
    
    return cell;
}

// To display the thumbnail size of images - Orginal images are resized to 85x85.
-(UIImage*)resizeImage:(UIImage*)image{
    CGSize destinationSize = CGSizeMake(85, 85);
    UIGraphicsBeginImageContext(destinationSize);
    [image drawInRect:CGRectMake(0,0,destinationSize.width,destinationSize.height)];
    UIImage *thumbImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbImage;
}

// From the description the height of the row would be calculated.
-(CGSize)heigtForCellwithString:(NSString *)stringValue withFont:(UIFont*)font{
    CGSize constraint = CGSizeMake(294,9999);
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [stringValue boundingRectWithSize:constraint
                                            options:         (NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                         attributes:attributes
                                            context:nil];
    return rect.size;
    
}

// It's delegate method of UITableView and the logic to be handle for different height of the row based on desc text.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize labelHeight;
    NSDictionary *filter = self.rowData[indexPath.row];
    NSString *descText = [filter objectForKey:@"description"];
    if (![descText isEqual:[NSNull null]]) {
        UIFont *font = [UIFont fontWithName:@"Verdana" size:18];
        labelHeight = [self heigtForCellwithString:descText    withFont:font];
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

// Delegate method. Table view is reloaded when the user rotate the orientation.
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [tableView reloadData];
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

@end
