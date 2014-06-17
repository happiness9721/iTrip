//
//  TripListTableViewController.m
//  iTrip
//
//  Created by 楊凱霖 on 6/13/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "TripListTableViewController.h"
#import "TripTabBarViewController.h"
#import "AppDelegate.h"
#import "Trip.h"

@interface TripListTableViewController ()

@property AppDelegate *delegate;
@property NSMutableArray *trips;
@property Trip *trip;

@end

@implementation TripListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.trips = [self.delegate getTrips];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate getTripCount];
}

// 以下程式碼請保留
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static int i=0;
//    UITableViewCell *cell;
//    if(i++%2==0){
//        cell = [self.tableView dequeueReusableCellWithIdentifier:@"tripCell"];
//    }
//    else{
//        cell = [self.tableView dequeueReusableCellWithIdentifier:@"secondCell"];
//    }
//    return cell.bounds.size.height;
//}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tripCellIdentifier"];
    return cell.bounds.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"tripCellIdentifier" forIndexPath:indexPath];
    Trip *trip = [self.trips objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString=[dateFormat stringFromDate:trip.date];
    UILabel * nameLabel = (UILabel*) [cell.contentView viewWithTag:1];
    UILabel * timeLabel = (UILabel*) [cell.contentView viewWithTag:2];
    UILabel * budgetLabel = (UILabel*) [cell.contentView viewWithTag:3];
    UILabel * restLabel = (UILabel*) [cell.contentView viewWithTag:4];
    nameLabel.text = trip.name;
    timeLabel.text =[self getDateDiff: trip.date];// dateString;
    budgetLabel.text = [NSString stringWithFormat:@"預算:%d", trip.budget];
    int cost = [self.delegate getChargePaySum:trip.tid];
    restLabel.text = [NSString stringWithFormat:@"尚餘:%d", trip.budget-cost];
    
    
//    [cell.textLabel setText:trip.name];
//    [cell.detailTextLabel setText:dateString];
    return cell;
    
// 
//    static int i=0;
//    UITableViewCell *cell;
//    if(i++%2==0){
//        cell = [tableView dequeueReusableCellWithIdentifier:@"tripCell" forIndexPath:indexPath];
//        
//        Trip *trip = [self.trips objectAtIndex:indexPath.row];
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"yyyy-MM-dd"];
//        NSString *dateString=[dateFormat stringFromDate:trip.date];
//        [cell.textLabel setText:trip.name];
//        [cell.detailTextLabel setText:dateString];
//    }else{
//        cell = [tableView dequeueReusableCellWithIdentifier:@"secondCell" forIndexPath:indexPath];
//        
//        Trip *trip = [self.trips objectAtIndex:indexPath.row];
//        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
//        [dateFormat setDateFormat:@"yyyy-MM-dd"];
//        NSString *dateString=[dateFormat stringFromDate:trip.date];
//        [cell.textLabel setText:trip.name];
//        [cell.detailTextLabel setText:dateString];
//    }
//    
//    
//    return cell;
}

-(NSString*) getDateDiff: (NSDate*) dateTime
{
    NSString* str;
    NSDate *fromDate = [NSDate date];
    NSDate *toDate = dateTime;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&fromDate
                 interval:NULL forDate:fromDate];
    [calendar rangeOfUnit:NSDayCalendarUnit startDate:&toDate
                 interval:NULL forDate:toDate];
    
    NSDateComponents *difference = [calendar components:NSDayCalendarUnit
                                               fromDate:fromDate toDate:toDate options:0];
    NSInteger integer = [difference day];
    if(integer >0){
        str = [NSString stringWithFormat:@"還剩下%d天", integer];
    }else if(integer==0){
        str = @"活動就在今天";
    }else
    {
        str = [NSString stringWithFormat:@"活動已經過了%d天", -integer];
    }
    return str;
}


-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.trip = [self.trips objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    TripTabBarViewController *destinationViewController = segue.destinationViewController;
    [destinationViewController setTrip:self.trip];
}

@end
