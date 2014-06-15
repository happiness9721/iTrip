//
//  SelectCoordinateViewController.m
//  iTrip
//
//  Created by 江承諭 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "SelectCoordinateViewController.h"
#import <MapKit/MapKit.h>
#import "MyLocation.h"

@interface SelectCoordinateViewController () <UISearchBarDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

@end

@implementation SelectCoordinateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 建立一個region，待會要設定給MapView
    MKCoordinateRegion kaos_digital;
    
    
    // 設定經緯度
    kaos_digital.center.latitude = 25.01141;
    kaos_digital.center.longitude = 121.42554;
    
    // 設定縮放比例
    kaos_digital.span.latitudeDelta = 0.007;
    kaos_digital.span.longitudeDelta = 0.007;
    
    // 把region設定給MapView
    [self.mapView setRegion:kaos_digital];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchCoordinatesForAddress:[searchBar text]];
    
    //Hide the keyboard.
    [searchBar resignFirstResponder];
}

- (void) searchCoordinatesForAddress:(NSString *)inAddress
{
    NSString *lookUpString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", inAddress];
    lookUpString = [lookUpString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    lookUpString = [lookUpString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSData *jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:lookUpString]];
    
    if (jsonResponse) {
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:nil];
        
        NSArray *locationArray = [[[jsonDict valueForKey:@"results"] valueForKey:@"geometry"] valueForKey:@"location"];
        
        locationArray = [locationArray objectAtIndex:0];
        
        NSString *latitudeString = [locationArray valueForKey:@"lat"];
        NSString *longitudeString = [locationArray valueForKey:@"lng"];
        
        NSLog(@"LatitudeString:%@ & LongitudeString:%@", latitudeString, longitudeString);
        [self zoomMapAndCenterAtLatitude:latitudeString.doubleValue andLongitude:longitudeString.doubleValue];
    }
    else
        NSLog(@"Got Nothing");
}


- (void) zoomMapAndCenterAtLatitude:(double) latitude andLongitude:(double) longitude
{
    MKCoordinateRegion region;
    region.center.latitude  = latitude;
    region.center.longitude = longitude;
    
    //Set Zoom level using Span
    MKCoordinateSpan span;
    span.latitudeDelta  = .005;
    span.longitudeDelta = .005;
    region.span = span;
    
    //Move the map and zoom
    [self.mapView setRegion:region animated:YES];
    MyLocation *myLocation = [[MyLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    myLocation.title = @"iTrip";
    myLocation.subtitle = @"媽，我在這裡啦!";
    [self.mapView addAnnotation:myLocation];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end