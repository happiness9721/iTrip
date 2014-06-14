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




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"Select Coordinate %@", segue.identifier);
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
