//
//  TripLogListTableViewController.m
//  iTrip
//
//  Created by 楊凱霖 on 6/16/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "TripLogListTableViewController.h"
#import "AppDelegate.h"
#import "Trip.h"
#import "TripLog.h"
#import "TripTabBarViewController.h"
#import <MapKit/MapKit.h>
#import "MyLocation.h"

@interface TripLogListTableViewController ()
@property AppDelegate *delegate;
@property NSMutableArray *tripLogs;
@property Trip *trip;

@end

@implementation TripLogListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    TripTabBarViewController *tripTabBarViewControll = (TripTabBarViewController *)self.tabBarController;
    self.trip = tripTabBarViewControll.trip;

    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tripLogs = [self.delegate getTripLogs:self.trip.tid];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.delegate getTripLogCount:self.trip.tid];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    TripLog* tripLog = [self.tripLogs objectAtIndex:indexPath.row];
    if([tripLog.type isEqualToString:TYPE_TEXT]){
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"textCellIdentifier"];
    }else if([tripLog.type isEqualToString:TYPE_IMAGE]){
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"imageCellIdentifier"];
    }else if([tripLog.type isEqualToString:TYPE_LOCATION]){
        cell = [self.tableView dequeueReusableCellWithIdentifier:@"locationCellIdentifier"];
    }
    return cell.bounds.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TripLog* tripLog = [self.tripLogs objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if([tripLog.type isEqualToString:TYPE_TEXT]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"textCellIdentifier" forIndexPath:indexPath];
        cell.textLabel.text = tripLog.text;
        cell.detailTextLabel.text = [dateFormatter stringFromDate:tripLog.time];
    }else if([tripLog.type isEqualToString:TYPE_IMAGE]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"imageCellIdentifier" forIndexPath:indexPath];
        UIImageView *uiImage = (UIImageView *)[cell.contentView viewWithTag:3];
        [uiImage setImage:tripLog.image];
        
//        UILabel *textLabel = (UILabel*)[cell.contentView viewWithTag:1];
//        textLabel.text = tripLog.text;
        UILabel *timeLabel = (UILabel*)[cell.contentView viewWithTag:2];
        timeLabel.text = [dateFormatter stringFromDate:tripLog.time];
    }else if([tripLog.type isEqualToString:TYPE_LOCATION]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"locationCellIdentifier" forIndexPath:indexPath];

        MKMapView* mapView = (MKMapView*)[cell.contentView viewWithTag:3];
//        UILabel* textLabel = (UILabel*)[cell.contentView viewWithTag:1];
//        textLabel.text = tripLog.text;
        UILabel* timeLabel = (UILabel*)[cell.contentView viewWithTag:2];
        timeLabel.text = [dateFormatter stringFromDate:tripLog.time];
        
        
        
        MKCoordinateRegion region;
        region.center.latitude = tripLog.latitude;
            region.center.longitude = tripLog.longitude;
        
        region.center.latitude = tripLog.latitude;
        region.center.longitude = tripLog.longitude;
        
        // 設定縮放比例
        region.span.latitudeDelta = 0.007;
        region.span.longitudeDelta = 0.007;
        
        // 把region設定給MapView
        [mapView setRegion:region];
        //Move the map and zoom
        MyLocation *myLocation = [[MyLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(tripLog.latitude, tripLog.longitude)];
        myLocation.title = @"iTrip";
        myLocation.subtitle = @"媽，我在這裡啦!";
        [mapView addAnnotation:myLocation];
        
        
    }
    
    return cell;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)unwindToTripLogList:(UIStoryboardSegue *)unwindSegue
{
    
}

@end
