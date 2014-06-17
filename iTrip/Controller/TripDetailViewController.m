//
//  TripDetailViewController.m
//  iTrip
//
//  Created by 江承諭 on 6/15/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "TripDetailViewController.h"
#import "TripTabBarViewController.h"
#import "SelectCoordinateViewController.h"
#import "AppDelegate.h"

@interface TripDetailViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *locationTextField;
@property (strong, nonatomic) IBOutlet UITextField *dateTextField;
@property (strong, nonatomic) IBOutlet UITextField *detailTextField;
@property (strong, nonatomic) IBOutlet UITextField *budgetTextField;
@property (strong, nonatomic) IBOutlet UITextField *costTextField;
@property (strong, nonatomic) IBOutlet UITextField *temperatureTextField;

@end

@implementation TripDetailViewController

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
    
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    TripTabBarViewController *tripTabBarViewControll = (TripTabBarViewController *)self.tabBarController;
    self.nameTextField.text = tripTabBarViewControll.trip.name;
    
    self.locationTextField.text = tripTabBarViewControll.trip.location;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    self.dateTextField.text = [dateFormat stringFromDate:tripTabBarViewControll.trip.date];
    self.detailTextField.text = tripTabBarViewControll.trip.detail;
    self.budgetTextField.text = [NSString stringWithFormat:@"%d",tripTabBarViewControll.trip.budget];
    int cost = [delegate getChargePaySum:tripTabBarViewControll.trip.tid];
    self.costTextField.text = [NSString stringWithFormat:@"%d", cost];
    
    
    
    Trip * trip = [[Trip alloc] init];
    trip.latitude = 25.131841;
    trip.longitude = 121.498494;
    [delegate.weather currentWeatherByTrip:trip andCallBack:^(NSString *cityName, NSNumber *temp) {
        NSString * tempStr = [NSString stringWithFormat:@"現在溫度(%.2lf)℃", [temp doubleValue]];
        self.temperatureTextField.text = tempStr;
    }];
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
    if ([segue.identifier isEqualToString:@"showMap"])
    {
        TripTabBarViewController *tripTabBarViewControll = (TripTabBarViewController *)self.tabBarController;
        SelectCoordinateViewController *destinationViewController = segue.destinationViewController;
        destinationViewController.latitude = tripTabBarViewControll.trip.latitude;
        destinationViewController.longitude = tripTabBarViewControll.trip.longitude;
        destinationViewController.location = tripTabBarViewControll.trip.location;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end
