//
//  SelectCoordinateViewController.m
//  iTrip
//
//  Created by 江承諭 on 6/14/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "SelectCoordinateViewController.h"
#import <MapKit/MapKit.h>

@interface SelectCoordinateViewController () <UISearchBarDelegate, NSURLConnectionDataDelegate>
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
//    [searchBar resignFirstResponder];
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    [geocoder geocodeAddressString:self.searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {
//        //Error checking
//        
//        CLPlacemark *placemark = [placemarks objectAtIndex:0];
//        MKCoordinateRegion region;
//        region.center = [(CLCircularRegion *)placemark.region center];
//        MKCoordinateSpan span;
//        double radius = [(CLCircularRegion*)placemark.region radius] / 1000; // convert to km
//        
//        NSLog(@"[searchBarSearchButtonClicked] Radius is %f", radius);
//        span.latitudeDelta = radius / 112.0;
//        
//        region.span = span;
//        
//        [self.mapView setRegion:region animated:YES];
//    }];
    //Perform the JSON query.
    [self searchCoordinatesForAddress:[searchBar text]];
    
    //Hide the keyboard.
    [searchBar resignFirstResponder];
}

- (void) searchCoordinatesForAddress:(NSString *)inAddress
{
    //Build the string to Query Google Maps.
    NSData *returnedData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://maps.googleapis.com/maps/api/geocode/json?address=taiwan&sensor=true_or_false"]];
    
    if (returnedData) {
        //NSLog(@"returnedData:%@", returnedData);
        NSString *jsonString = [[NSString alloc] initWithData:returnedData encoding:NSUTF8StringEncoding];
        NSDictionary *results = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        NSString *resultsData = (NSString*)[results objectForKey:@"results"];
        NSLog(@"jsonDict:%@", resultsData);
    }
    else
        NSLog(@"Got Nothing");
}

//It's called when the results of [[NSURLConnection alloc] initWithRequest:request delegate:self] come back.
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //The string received from google's servers
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //JSON Framework magic to obtain a dictionary from the jsonString.
    NSDictionary *results = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];;
    
    //Now we need to obtain our coordinates
    NSArray *placemark  = [results objectForKey:@"Placemark"];
    NSArray *coordinates = [[placemark objectAtIndex:0] valueForKeyPath:@"Point.coordinates"];
    
    //I put my coordinates in my array.
    double longitude = [[coordinates objectAtIndex:0] doubleValue];
    double latitude = [[coordinates objectAtIndex:1] doubleValue];
    
    //Debug.
    //NSLog(@"Latitude - Longitude: %f %f", latitude, longitude);
    
    //I zoom my map to the area in question.
    [self zoomMapAndCenterAtLatitude:latitude andLongitude:longitude];
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
