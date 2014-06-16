//
//  ChargeViewController.m
//  iTrip
//
//  Created by 江承諭 on 6/16/14.
//  Copyright (c) 2014 楊凱霖. All rights reserved.
//

#import "ChargeViewController.h"
#import "CustomIOS7AlertView.h"
#import "AppDelegate.h"
#import "TripTabBarViewController.h"
#import "ChargeListTableViewController.h"
#import "Charge.h"

@interface ChargeViewController () <CustomIOS7AlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *budgetText;
@property (strong, nonatomic) IBOutlet UITextField *costText;
@property (strong, nonatomic) IBOutlet UITextField *restText;
@property (strong, nonatomic) IBOutlet UITableViewController *containerViewController;

@end

@implementation ChargeViewController

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
    int budget = tripTabBarViewControll.trip.budget;
    int cost = [delegate getChargePaySum:tripTabBarViewControll.trip.tid];
    self.budgetText.text = [NSString stringWithFormat:@"%d", budget];
    self.costText.text = [NSString stringWithFormat:@"%d", cost];
    self.restText.text = [NSString stringWithFormat:@"%d", budget - cost];
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
    if ([segue.identifier isEqualToString:@"containerView"])
    {
        self.containerViewController = segue.destinationViewController;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)addCharge:(id)sender
{
    CustomIOS7AlertView *alertView = [[CustomIOS7AlertView alloc] init];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"完成", nil]];
    UIViewController *customViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"chargeCheck"];
    UIView *customView = customViewController.view;
    customView.frame = CGRectMake(0, 0, 180, 100);
    
    [alertView setContainerView:customView];
    [alertView setDelegate:self];
    [alertView show];
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOS7AlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    //取消0
    if (buttonIndex == 1)
    {
        UITextField *nameTextField = (UITextField *)[alertView viewWithTag:5];
        UITextField *payTextField = (UITextField *)[alertView viewWithTag:6];
        NSString *name = nameTextField.text;
        int pay = payTextField.text.intValue;
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        TripTabBarViewController *tripTabBarViewControll = (TripTabBarViewController *)self.tabBarController;
        Charge *newCharge = [[Charge alloc] init];
        newCharge.name = name;
        newCharge.pay = pay;
        newCharge.tid = tripTabBarViewControll.trip.tid;
        [delegate addCharge:newCharge];
        [(ChargeListTableViewController *)self.containerViewController reloadTableList];
        int budget = tripTabBarViewControll.trip.budget;
        int cost = [delegate getChargePaySum:tripTabBarViewControll.trip.tid];
        self.costText.text = [NSString stringWithFormat:@"%d", cost];
        self.restText.text = [NSString stringWithFormat:@"%d", budget - cost];
    }
    [alertView close];
}

@end
