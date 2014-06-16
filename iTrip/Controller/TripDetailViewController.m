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

@interface TripDetailViewController ()
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;

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
    TripTabBarViewController *tripTabBarViewControll = (TripTabBarViewController *)self.tabBarController;
    self.nameTextField.text = tripTabBarViewControll.trip.name;
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
